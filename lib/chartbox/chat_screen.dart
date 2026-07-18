import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/chartbox/bolc/chat_bloc.dart';
import 'package:medicompare/chartbox/bolc/chat_event.dart';
import 'package:medicompare/chartbox/bolc/chat_state.dart';
import 'package:medicompare/chartbox/repository/chat_repository.dart';
import 'package:medicompare/chartbox/widget/chat_appbar.dart';
import 'package:medicompare/chartbox/widget/message_bubble.dart';
import 'package:medicompare/chartbox/widget/message_input.dart';
import 'package:medicompare/chartbox/widget/today_chip.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ChatBloc(repository: ChatRepository())..add(const LoadChat()),
      child: const _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  const _ChatView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ChatAppBar(),

            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state.status == ChatStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 20,
                    ),
                    itemCount: state.messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return const TodayChip();
                      }

                      final message = state.messages[index - 1];

                      return MessageBubble(message: message);
                    },
                  );
                },
              ),
            ),

            const MessageInput(),
          ],
        ),
      ),
    );
  }
}
