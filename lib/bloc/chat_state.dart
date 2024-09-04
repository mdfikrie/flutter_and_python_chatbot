part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  final List<({Image? image, String? text, bool? fromUser})>? generatedMessage;
  final String? error;
  const ChatState({
    this.generatedMessage,
    this.error,
  });

  @override
  List<Object> get props => [generatedMessage!];
}

final class ChatInitial extends ChatState {
  ChatInitial({super.generatedMessage});
}

final class ChatInProgress extends ChatState {
  ChatInProgress({super.generatedMessage});
}

final class ChatComplete extends ChatState {
  ChatComplete({super.generatedMessage});
}

final class ChatError extends ChatState {
  ChatError({super.generatedMessage, super.error});
}
