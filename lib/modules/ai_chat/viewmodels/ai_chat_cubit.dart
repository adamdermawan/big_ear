// lib/ai_chat/viewmodels/ai_chat_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'ai_chat_state.dart';

// MODIFIED: Re-import your data formatter. This is now crucial.
import 'package:big_ear/core/mock/gemini_data_formatter.dart'; 

// IMPORTANT: Replace with your actual Gemini API Key.
const String _apiKey = 'YOUR_GEMINI_API_KEY';

class AiChatCubit extends Cubit<AiChatState> {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  bool _isInitialized = false; // Add a flag to track successful initialization

  AiChatCubit() : super(AiChatInitial()) {
    if (_apiKey == 'YOUR_GEMINI_API_KEY' || _apiKey.isEmpty) {
      emit(
        AiChatError(
          "Something went wrong on our end. Please try again later.",
        ),
      );
      // IMPORTANT: Add a return statement here to prevent further initialization
      return; 
    }

    try {
      _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);
      _chat = _model.startChat();
      _isInitialized = true; // Mark as successfully initialized
    } catch (e) {
      // Catch any errors during model/chat initialization (e.g., invalid API key format)
      emit(
        AiChatError(
          "Something went wrong initializing our AI. Please try again later.",
        ),
      );
      print('Error during AI model initialization: $e');
      // No need for 'return' here as the constructor will finish,
      // but _isInitialized will remain false, preventing `sendPrompt` from running.
    }
  }

  Future<void> sendPrompt(String userPrompt) async {
    // Prevent sending prompts if the model wasn't successfully initialized
    if (!_isInitialized) {
      // You could optionally emit a more specific error here if you want,
      // but the initial error state should already be active.
      return; 
    }

    if (userPrompt.trim().isEmpty) {
      return;
    }

    emit(AiChatLoading());

    try {
      final String productDataContext = formatDataForGemini();

      final String finalPrompt = """
      **ROLE AND INSTRUCTION:**
      Anda adalah asisten AI yang ramah dan membantu untuk aplikasi e-commerce yang menjual kasur dan produk perlengkapan tidur.
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

      if (response.text != null && response.text!.isNotEmpty) {
        emit(AiChatLoaded(response.text!));
      } else {
        emit(
          AiChatLoaded(
            "I'm sorry, I couldn't generate a response. Please try rephrasing your question.",
          ),
        );
      }
    } catch (e) {
      // This catch block handles errors during the actual content generation,
      // not initialization.
      emit(
        AiChatError(
          "We're having trouble getting a response from our AI. Please try again.",
        ),
      );
      print('Error calling Gemini API: $e');
    }
  }
}