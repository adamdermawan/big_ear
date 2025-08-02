// lib/ai_chat/viewmodels/ai_chat_cubit.dart

import 'package:big_ear/modules/ai_chat/model/chat_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:big_ear/modules/ai_chat/model/gemini_data_formatter.dart';
import 'ai_chat_state.dart';

const String _apiKey = 'YOUR_GEMINI_API_KEY'; // IMPORTANT: Use your actual key

class AiChatCubit extends Cubit<AiChatState> {
  late final GenerativeModel _model;
  bool _isInitialized = false;

  AiChatCubit() : super(const AiChatSuccess()) {
    if (_apiKey == 'YOUR_GEMINI_API_KEY' || _apiKey.isEmpty) {
      emit(const AiChatError("Something Went Wrong."));
      return;
    }

    try {
      _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);
      _isInitialized = true;
    } catch (e) {
      emit(AiChatError("Failed to initialize AI: ${e.toString()}"));
    }
  }

  Future<void> sendPrompt(String userPrompt) async {
    if (!_isInitialized || userPrompt.trim().isEmpty) {
      return;
    }
    
    final currentState = state;
    if (currentState is! AiChatSuccess) return;

    // Step 1: Add user message and set loading state.
    final userMessage = ChatMessage(text: userPrompt, author: MessageAuthor.user);
    emit(currentState.copyWith(
      messages: [...currentState.messages, userMessage],
      isLoading: true,
    ));

    try {
      // MODIFIED: Use the new async version that fetches real data
      final String productDataContext = await formatDataForGemini();
      
      final String finalPrompt = """
      **ROLE AND INSTRUCTION:**
      Anda adalah asisten AI yang ramah dan membantu untuk aplikasi e-commerce yang menjual kasur ,springbed dan produk perlengkapan tidur.
      Tugas Anda HANYA menjawab pertanyaan pengguna berdasarkan konteks "DATA PRODUK" yang disediakan di bawah ini.
      
      **PERATURAN:**
      1. Jawab HANYA menggunakan informasi dari bagian "DATA PRODUK". Jangan gunakan informasi eksternal apa pun.
      2. Jika pengguna bertanya tentang sesuatu yang tidak disebutkan dalam data (misalnya, "Apakah Anda menjual meja?", "Bagaimana cuacanya?"), Anda HARUS dengan sopan mengatakan bahwa Anda hanya dapat menjawab pertanyaan tentang katalog produk yang disediakan.
      3. Analisis ulasan untuk memahami sentimen pelanggan (apa yang mereka suka dan tidak suka).
      4. Pastikan jawaban Anda ringkas dan komunikatif.
      
      ---
      **PRODUCT DATA:**
      $productDataContext
      ---
      
      **USER'S QUESTION:**
      $userPrompt
      """;
      
      final content = [Content.text(finalPrompt)];
      final response = await _model.generateContent(content);

      // Step 2: Add AI response and clear loading state.
      if (response.text != null && response.text!.isNotEmpty) {
        final modelMessage = ChatMessage(text: response.text!, author: MessageAuthor.model);
        final latestState = state as AiChatSuccess;
        emit(latestState.copyWith(
          messages: [...latestState.messages, modelMessage],
          isLoading: false,
        ));
      } else {
        throw Exception("Received an empty response from AI.");
      }
    } catch (e) {
      final errorMessage = ChatMessage(
        text: "Oops! Something went wrong. Please try again.",
        author: MessageAuthor.model, // Show error as a message from the "model"
      );
      final latestState = state as AiChatSuccess;
      emit(latestState.copyWith(
        messages: [...latestState.messages, errorMessage],
        isLoading: false,
      ));
      print('Error calling Gemini API: $e');
    }
  }
}