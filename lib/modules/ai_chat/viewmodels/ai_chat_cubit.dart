// lib/ai_chat/viewmodels/ai_chat_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:big_ear/core/mock/gemini_data_formatter.dart'; // Import your mock data and formatting function
import 'ai_chat_state.dart';

// IMPORTANT: Replace with your actual Gemini API Key.
// For production, consider using environment variables (e.g., flutter_dotenv package)
// or a secure server-side proxy to keep your API key safe.
const String _apiKey = 'AIzaSyDa1aYlklX-Y8vEzWNmKjQ_hcLw78xmhhg';

class AiChatCubit extends Cubit<AiChatState> {
  late final GenerativeModel _model;

  AiChatCubit() : super(AiChatInitial()) {
    if (_apiKey == 'YOUR_GEMINI_API_KEY' || _apiKey.isEmpty) {
      emit(
        AiChatError(
          "Gemini API Key is not set or is empty. Please use your actual Gemini API key.",
        ),
      );
      return;
    }
    _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: _apiKey);
  }

  Future<void> analyzeProductData() async {
    if (state is AiChatError &&
        (state as AiChatError).error.contains('API Key is not set')) {
      return;
    }

    emit(AiChatLoading());

    try {
      final String formattedData =
          formatDataForGemini(); // Get your formatted mock data

      // --- MODIFIED PROMPT BELOW ---
      final String prompt =
          """
      Hai! Saya di sini untuk membantu Anda memahami pendapat orang-orang tentang produk ini.
      Mari kita lihat deskripsi dan ulasan pelanggan, dan saya akan memberikan ringkasan yang ramah dan komunikatif.

      Untuk setiap produk, saya akan memberi tahu Anda tentang:
      - Perasaan umum dari ulasan (apakah orang-orang senang, beragam, atau tidak begitu senang?)
      - Apa saja pro dan kontra utama, berdasarkan apa yang dibagikan pelanggan.
      - Komentar menarik atau menonjol yang menarik perhatian saya.
      - Pendapat saya secara keseluruhan atau rekomendasi singkat tentang produk ini.

      Sampaikan informasi ini dengan gaya percakapan yang mengalir dan alami, seolah-olah Anda sedang menjelaskannya kepada seorang teman.
      Yang terpenting, **jangan gunakan format markdown** seperti huruf tebal (**), huruf miring (*), poin-poin (- atau *), atau daftar bernomor (1. 2.) dalam tanggapan Anda. Cukup berikan teks biasa.
      Pastikan analisis hanya berdasarkan data yang diberikan di bawah ini, tanpa menambahkan informasi tambahan apa pun.

      ---
      Product Data:
      $formattedData
      ---
      """;
      // --- END OF MODIFIED PROMPT ---

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text != null && response.text!.isNotEmpty) {
        emit(AiChatLoaded(response.text!));
      } else {
        emit(
          AiChatLoaded(
            "It seems I couldn't generate a clear analysis based on the data right now. Could you try again or perhaps provide more specific data?",
          ),
        );
      }
    } catch (e) {
      emit(
        AiChatError(
          "Oops! Something went wrong while trying to analyze the data: ${e.toString()}\nPlease check your internet connection and Gemini API key, then try again.",
        ),
      );
      print('Error calling Gemini API: $e'); // For debugging
    }
  }
}// For debugging purposes
 
