part of 'message_cubit.dart';

@immutable
sealed class MessageState {}

final class MessageInitial extends MessageState {}

final class MessageLoading extends MessageState {}

final class MessageLoaded extends MessageState {
  final List<ChatModel>? chats;
  MessageLoaded({this.chats});
}

final class MessageError extends MessageState {}
