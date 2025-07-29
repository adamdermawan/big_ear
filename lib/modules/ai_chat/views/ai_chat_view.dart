// lib/ai_chat/views/ai_chat_view.dart

import 'package:big_ear/modules/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../viewmodels/ai_chat_cubit.dart';
import '../viewmodels/ai_chat_state.dart';

class AIChatView extends StatefulWidget {
  const AIChatView({super.key});

  @override
  State<AIChatView> createState() => _AIChatViewState();
}

class _AIChatViewState extends State<AIChatView> {
  // MODIFIED: Add a controller for the text field
  late final TextEditingController _promptController;

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController();
    // MODIFIED: Removed the automatic call to analyze data.
  }

  // MODIFIED: Dispose the controller to prevent memory leaks
  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }
  
  // MODIFIED: Extracted the send logic into a helper method
  void _submitPrompt() {
    final prompt = _promptController.text;
    if (prompt.isNotEmpty) {
      context.read<AiChatCubit>().sendPrompt(prompt);
      _promptController.clear(); // Clear the text field after sending
      FocusScope.of(context).unfocus(); // Hide keyboard
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
      // MODIFIED: Added Padding and a Column to structure the view
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // This part will show the AI response and fill available space
            Expanded(
              child: BlocBuilder<AiChatCubit, AiChatState>(
                builder: (context, state) {
                  if (state is AiChatLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
                      ),
                    );
                  } else if (state is AiChatLoaded) {
                    return _buildResponseCard(state.message);
                  } else if (state is AiChatError) {
                    return _buildErrorWidget(state.error);
                  }
                  // MODIFIED: Show an initial welcome message
                  return _buildInitialView();
                },
              ),
            ),
            const SizedBox(height: 16),
            // MODIFIED: This is the new input field section
            _buildPromptInput(),
          ],
        ),
      ),
    );
  }

  // MODIFIED: New widget for the initial screen
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

  // MODIFIED: New widget for the text input field and send button
  Widget _buildPromptInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _promptController,
            decoration: InputDecoration(
              hintText: 'Tulis pertanyaanmu disini...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onSubmitted: (_) => _submitPrompt(),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: _submitPrompt,
          style: IconButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  // MODIFIED: Refactored response view into its own widget
  Widget _buildResponseCard(String message) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueGrey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SelectableText(
          message,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }

  // MODIFIED: Refactored error view into its own widget
  Widget _buildErrorWidget(String error) {
    return Center(
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
    );
  }
}