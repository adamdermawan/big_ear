// lib/ai_chat/viewmodels/ai_chat_state.dart

 // MODIFIED: Import our new message model

import 'package:big_ear/modules/ai_chat/model/chat_message.dart';

abstract class AiChatState {
  const AiChatState();
}

class AiChatInitial extends AiChatState {}

// MODIFIED: This is now the main state for the chat screen.
// It holds the entire conversation history and loading status.
class AiChatSuccess extends AiChatState {
  final List<ChatMessage> messages;
  final bool isLoading;

  const AiChatSuccess({
    this.messages = const [],
    this.isLoading = false,
  });

  // Helper method to easily create a new state with updated values.
  AiChatSuccess copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
  }) {
    return AiChatSuccess(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AiChatError extends AiChatState {
  final String error;
  const AiChatError(this.error);
}