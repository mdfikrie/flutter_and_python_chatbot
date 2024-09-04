part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  final String? text;
  const ChatEvent({this.text});

  @override
  List<Object> get props => [];
}

class ChatInit extends ChatEvent {
  ChatInit({super.text});
}

class SendChatMessage extends ChatEvent {
  SendChatMessage({super.text});
}
