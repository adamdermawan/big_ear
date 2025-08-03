// lib/ai_chat/views/ai_chat_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:big_ear/modules/shared/constants/colors.dart'; // Make sure this path is correct for your project
import '../viewmodels/ai_chat_cubit.dart';
import '../viewmodels/ai_chat_state.dart';
import 'package:big_ear/modules/ai_chat/model/chat_message.dart';
 // Import the message model

class AIChatView extends StatefulWidget {
  const AIChatView({super.key});

  @override
  State<AIChatView> createState() => _AIChatViewState();
}

class _AIChatViewState extends State<AIChatView> {
  late final TextEditingController _promptController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _submitPrompt() {
    final prompt = _promptController.text;
    if (prompt.isNotEmpty) {
      context.read<AiChatCubit>().sendPrompt(prompt);
      _promptController.clear();
      FocusScope.of(context).unfocus();
    }
  }
  
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      // A short delay ensures the UI has built the new item before we scroll.
      Future.delayed(const Duration(milliseconds: 50), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: BlocListener<AiChatCubit, AiChatState>(
                listener: (context, state) {
                  if (state is AiChatSuccess) {
                    _scrollToBottom();
                  }
                },
                child: BlocBuilder<AiChatCubit, AiChatState>(
                  builder: (context, state) {
                    if (state is AiChatSuccess) {
                      if (state.messages.isEmpty) {
                        return _buildInitialView();
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        itemCount: state.messages.length + (state.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (state.isLoading && index == state.messages.length) {
                            return const _ChatMessageBubble(
                              author: MessageAuthor.model,
                              isTyping: true,
                            );
                          }
                          final message = state.messages[index];
                          return _ChatMessageBubble(
                            message: message.text,
                            author: message.author,
                          );
                        },
                      );
                    } else if (state is AiChatError) {
                      return _buildErrorWidget(state.error);
                    }
                    return _buildInitialView(); // Default for AiChatInitial
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildPromptInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.smart_toy_outlined, size: 80, color: primaryBlue),
          const SizedBox(height: 20),
          const Text(
            'Hallo!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Apa yang ingin kamu tanyakan?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

Widget _buildPromptInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4, right: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end, // Align to bottom when text expands
        children: [
          Expanded(
            child: TextField(
              controller: _promptController,
              maxLines: null, // Allow unlimited lines
              minLines: 1,    // Start with 1 line
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline, // Allow new lines
              decoration: InputDecoration(
                hintText: 'Tulis pertanyaanmu disini...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: primaryBlue, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              // Remove onSubmitted to prevent sending on Enter
              // onSubmitted: (_) => _submitPrompt(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _submitPrompt,
            style: IconButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(14),
              shape: const CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessageBubble extends StatelessWidget {
  const _ChatMessageBubble({
    this.message,
    required this.author,
    this.isTyping = false,
  });

  final String? message;
  final MessageAuthor author;
  final bool isTyping;

  @override
  Widget build(BuildContext context) {
    final isUser = author == MessageAuthor.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isUser ? primaryBlue : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: isTyping
            ? const SizedBox(
                width: 50,
                height: 20,
                child: Center(
                  // A simple typing indicator
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                ),
              )
            : SelectableText(
                message ?? '',
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}