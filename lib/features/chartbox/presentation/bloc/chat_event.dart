import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

/// Load all messages
class LoadChat extends ChatEvent {
  const LoadChat();
}

/// Send a message
class SendMessage extends ChatEvent {
  final String message;

  const SendMessage(this.message);

  @override
  List<Object?> get props => [message];
}

/// Typing status
class TypingChanged extends ChatEvent {
  final bool isTyping;

  const TypingChanged(this.isTyping);

  @override
  List<Object?> get props => [isTyping];
}
