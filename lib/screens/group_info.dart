import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/shared/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfor extends StatefulWidget {
  const GroupInfor(
      {Key? key,
      required this.groupName,
      required this.adminName,
      required this.groupId})
      : super(key: key);
  final String groupName;
  final String adminName;
  final String groupId;

  @override
  State<GroupInfor> createState() => _GroupInforState();
}

class _GroupInforState extends State<GroupInfor> {
  Stream? members;

  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf(("_")) + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Group Infor"),
          elevation: 0,
          backgroundColor: Constants.primaryColor,
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.exit_to_app))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Constants.primaryColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30)),
                  child: Container(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          widget.groupName.substring(0, 1).toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Group: ${widget.groupName}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Admin: ${getName(widget.adminName)}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 10,),
              memberList(),
            ],
          ),
        ));
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data["members"] != null) {
            if (snapshot.data["members"].length != 0) {
              return ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        getName(snapshot.data['members'][index])
                            .substring(0, 1),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getName(snapshot.data['members'][index]),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          getId(snapshot.data['members'][index]),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: snapshot.data["members"].length,
              );
            } else {
              return const Center(
                child: Text(
                  "No members",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              );
            }
          } else {
            return const Center(
              child: Text(
                "No members",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            );
          }
        } else {
          debugPrint("Come here");
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
