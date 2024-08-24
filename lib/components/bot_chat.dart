import 'package:flutter/material.dart';
import 'package:flutter_chatbot/models/chat_model.dart';

class BotChat extends StatelessWidget {
  final ChatModel? chat;
  const BotChat({super.key, this.chat});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Text(
            "${chat!.message}",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
