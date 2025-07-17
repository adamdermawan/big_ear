import 'package:flutter_bloc/flutter_bloc.dart';
import 'ai_chat_state.dart';

class AiChatCubit extends Cubit<AiChatState> {
  AiChatCubit() : super(AiChatInitial());

  void loadAiChat() async {
    emit(AiChatLoading());

    await Future.delayed(const Duration(seconds: 2)); // simulate API delay

    try {
      emit(AiChatLoaded("This is AI Page Still in Construction"));
    } catch (e) {
      emit(AiChatError("Failed to load..."));
    }
  }
}
