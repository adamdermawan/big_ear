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
  @override
  void initState() {
    super.initState();
    context.read<AiChatCubit>().loadAiChat();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiChatCubit, AiChatState>(
      builder: (context, state) {
        if (state is AiChatLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AiChatLoaded) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/construction.jpg',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else if (state is AiChatError) {
          return Center(
            child: Text(state.error, style: const TextStyle(color: Colors.red)),
          );
        }
        return const Center(child: Text('AI Chat Page'));
      },
    );
  }
}
