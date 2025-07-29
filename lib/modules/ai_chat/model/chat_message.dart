// lib/ai_chat/viewmodels/chat_message.dart

// NEW: An enum to identify who sent the message.
enum MessageAuthor {
  user,
  model, // Represents the AI
}

// NEW: A class to hold the content and author of a single message.
class ChatMessage {
  final String text;
  final MessageAuthor author;

  ChatMessage({
    required this.text,
    required this.author,
  });
}