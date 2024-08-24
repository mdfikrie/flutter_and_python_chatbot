import 'package:flutter/material.dart';
import 'package:flutter_chatbot/models/chat_model.dart';

class UserChat extends StatelessWidget {
  final ChatModel? chat;
  const UserChat({super.key, this.chat});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
          ),
          child: Text(
            "${chat!.message}",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
