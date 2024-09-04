import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter_chatbot/models/chat_model.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  List<ChatModel> chats = <ChatModel>[];

  final base_url = "http://127.0.0.1:5000";

  void sendMessage({required String message}) async {
    emit(MessageLoading());
    chats.add(ChatModel(
      author: 1,
      message: message,
      createdAt: DateTime.now(),
    ));
    emit(MessageLoaded(chats: chats));
    // interact with bot
    try {
      final response = await http.post(
        Uri.parse("${base_url}/chat"),
        headers: {"Content-Type": "application/json"}, // Specify content type
        body: jsonEncode({"message": message}), // Encode the body as JSON
      );

      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        chats.add(ChatModel(
          author: 0,
          message: result['response'],
          createdAt: DateTime.now(),
        ));
        emit(MessageLoaded(chats: chats));
      } else {
        print(
            "Failed to communicate with server. Status code: ${response.statusCode}");
        // Handle error based on status code
      }
    } catch (e) {
      print("Error: $e");
      // Handle network error, show message to user, etc.
    }
  }
}
