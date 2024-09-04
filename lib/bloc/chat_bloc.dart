import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  late final GenerativeModel _model;
  final _apiKey = "AIzaSyC3hpQtnJ9sJNQ5Wi1JBR0ofwNk4xJx5xE";
  final List<({Image? image, String? text, bool? fromUser})> _generatedContent =
      <({Image? image, String? text, bool? fromUser})>[];

  ChatBloc() : super(ChatInitial()) {
    on<ChatInit>(_chatInit);
    on<SendChatMessage>(_sendChatMessage);
  }

  void _chatInit(ChatInit event, Emitter<ChatState> emit) {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: _apiKey,
    );
  }

  void _sendChatMessage(SendChatMessage event, Emitter<ChatState> emit) async {
    _generatedContent.add((fromUser: true, text: event.text, image: null));
    emit(ChatComplete(generatedMessage: _generatedContent));
    try {
      emit(ChatInProgress(generatedMessage: _generatedContent));
      final prompt = [Content.text(event.text ?? "")];
      final _response = await _model.generateContent(prompt);
      final text = _response.text;
      _generatedContent.add((fromUser: false, text: text, image: null));
      emit(ChatComplete(generatedMessage: _generatedContent));
    } catch (e) {
      emit(ChatError(generatedMessage: _generatedContent, error: "Error"));
    }
  }
}
