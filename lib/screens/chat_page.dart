import 'package:chat_app/screens/group_info.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/shared/constant.dart';
import 'package:chat_app/widgets/messgage_title.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String admin = "";

  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    getChatAndAdmin();
    super.initState();
  }

  getChatAndAdmin() {
    DatabaseService().getChats(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((value) {
      admin = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        elevation: 0,
        backgroundColor: Constants.primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              nextSceen(
                  context,
                  GroupInfor(
                    groupName: widget.groupName,
                    adminName: admin,
                    groupId: widget.groupId,
                  ));
            },
            icon: const Icon(Icons.info_outline)
          )
        ],
      ),
      body: Stack(
        children: [
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            child: Container(
              //padding: const EdgeInsets.all(15),
              color: Colors.grey[700],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: TextField(
                    controller: messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Send a message",
                      border: InputBorder.none,
                    ),
                  )),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Constants.primaryColor.withOpacity(0.6),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
          ? Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: ((context, index) {
                debugPrint("sender: ${snapshot.data.docs[index]['sender']}");
                debugPrint("user: ${widget.userName}");
                debugPrint("message: ${snapshot.data.docs[index]['message']}");
                return MessageTitle(
                  message: snapshot.data.docs[index]['message'],
                  sender: snapshot.data.docs[index]['sender'],
                  senbyMe: snapshot.data.docs[index]['sender'] ==
                    widget.userName
                )
                ;
              }),
            ),
          )
          : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessage = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecond
      };
      DatabaseService().sendMessage(widget.groupId, chatMessage);
      setState(() {
        messageController.clear();
      });
    }
  }
}
