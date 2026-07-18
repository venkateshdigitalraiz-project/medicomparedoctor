import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/chartbox/bolc/chat_event.dart';
import 'package:medicompare/chartbox/bolc/chat_state.dart';
import 'package:medicompare/chartbox/model/message_model.dart';
import 'package:medicompare/chartbox/repository/chat_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;

  ChatBloc({required this.repository}) : super(const ChatState()) {
    on<LoadChat>(_onLoadChat);

    on<SendMessage>(_onSendMessage);

    on<TypingChanged>(_onTypingChanged);
  }

  Future<void> _onLoadChat(LoadChat event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading));

    try {
      final messages = await repository.getMessages();

      emit(state.copyWith(status: ChatStatus.success, messages: messages));
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.failure, error: e.toString()));
    }
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    if (event.message.trim().isEmpty) return;

    final list = List<MessageModel>.from(state.messages);

    list.add(
      MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: event.message,
        time: _currentTime(),
        isMe: true,
      ),
    );

    emit(state.copyWith(messages: list));
  }

  void _onTypingChanged(TypingChanged event, Emitter<ChatState> emit) {
    emit(state.copyWith(isTyping: event.isTyping));
  }

  String _currentTime() {
    final now = DateTime.now();

    int hour = now.hour;
    final minute = now.minute.toString().padLeft(2, '0');

    final period = hour >= 12 ? "pm" : "am";

    hour = hour % 12;

    if (hour == 0) {
      hour = 12;
    }

    return "$hour:$minute $period";
  }
}
