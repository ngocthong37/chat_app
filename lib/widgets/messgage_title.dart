import 'package:flutter/material.dart';

class MessageTitle extends StatefulWidget {
  const MessageTitle(
      {Key? key,
      required this.message,
      required this.sender,
      required this.senbyMe})
      : super(key: key);

  final String message;
  final String sender;
  final bool senbyMe;

  @override
  State<MessageTitle> createState() => _MessageTitleState();
}

class _MessageTitleState extends State<MessageTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
      child: Align(
        alignment: widget.senbyMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.only(
            left: widget.senbyMe ?  10 : 30, 
            right: widget.senbyMe ? 30 : 10, 
            top: 5, 
            bottom: 5
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.senbyMe ? Colors.blue.withOpacity(0.8) : Colors.grey[700]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.sender,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 8,),
              Text(
                widget.message,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
