// lib/ai_chat/viewmodels/ai_chat_state.dart

abstract class AiChatState {}

class AiChatInitial extends AiChatState {}

class AiChatLoading extends AiChatState {}

class AiChatLoaded extends AiChatState {
  final String message;
  AiChatLoaded(this.message);
}

class AiChatError extends AiChatState {
  final String error;
  AiChatError(this.error);
}
