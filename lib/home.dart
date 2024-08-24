import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatbot/components/bot_chat.dart';
import 'package:flutter_chatbot/components/user_chat.dart';
import 'package:flutter_chatbot/cubit/message/message_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController message;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    message = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Chatbot Apps"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocListener<MessageCubit, MessageState>(
                listener: (context, state) {
                  if (state is MessageLoaded) {
                    scrollController.jumpTo(
                        scrollController.position.maxScrollExtent + 100);
                  }
                },
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: BlocBuilder<MessageCubit, MessageState>(
                      builder: (context, state) {
                        if (state is MessageLoaded) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.chats!.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) =>
                                state.chats![index].author == 0
                                    ? BotChat(
                                        chat: state.chats![index],
                                      )
                                    : UserChat(
                                        chat: state.chats![index],
                                      ),
                          );
                        }
                        return Center(
                          child: SizedBox(),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Container(
              // height: 55,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: message,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Tulisa pesan..",
                      ),
                      onEditingComplete: () {
                        context
                            .read<MessageCubit>()
                            .sendMessage(message: message.text);
                        message.text = "";
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context
                          .read<MessageCubit>()
                          .sendMessage(message: message.text);
                      message.text = "";
                    },
                    // padding: EdgeInsets.all(5),
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
