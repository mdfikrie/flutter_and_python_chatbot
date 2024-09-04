import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatbot/bloc/chat_bloc.dart';
import 'package:flutter_chatbot/components/bot_chat.dart';
import 'package:flutter_chatbot/components/user_chat.dart';

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
    context.read<ChatBloc>().add(ChatInit());
    message = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Flutter Gemini"),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: BlocConsumer<ChatBloc, ChatState>(
                    listener: (context, state) {
                      _scrollDown();
                    },
                    builder: (context, state) {
                      if (state.generatedMessage == null ||
                          state.generatedMessage!.isEmpty) {
                        return SizedBox();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Center(
                            child: SizedBox(
                              width: kIsWeb
                                  ? 500
                                  : MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.generatedMessage!.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var content = state.generatedMessage![index];
                                  if (state.generatedMessage![index].fromUser ==
                                      false) {
                                    return BotChat(
                                      text: content.text,
                                    );
                                  } else {
                                    return UserChat(
                                      text: content.text,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: kIsWeb ? 500 : MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: message,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter prompt..",
                        ),
                        onEditingComplete: () {
                          // context
                          //     .read<MessageCubit>()
                          //     .sendMessage(message: message.text);
                          context
                              .read<ChatBloc>()
                              .add(SendChatMessage(text: message.text));
                          message.text = "";
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // context
                        //     .read<MessageCubit>()
                        //     .sendMessage(message: message.text);
                        context
                            .read<ChatBloc>()
                            .add(SendChatMessage(text: message.text));
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
      ),
    );
  }
}
