import 'package:equatable/equatable.dart';
import 'package:medicompare/chartbox/model/message_model.dart';

enum ChatStatus { initial, loading, success, failure }

class ChatState extends Equatable {
  final ChatStatus status;

  final List<MessageModel> messages;

  final bool isTyping;

  final String error;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.isTyping = false,
    this.error = "",
  });

  ChatState copyWith({
    ChatStatus? status,
    List<MessageModel>? messages,
    bool? isTyping,
    String? error,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, messages, isTyping, error];
}
