import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String id;
  final String message;
  final String time;
  final bool isMe;

  const MessageModel({
    required this.id,
    required this.message,
    required this.time,
    required this.isMe,
  });

  @override
  List<Object?> get props => [id, message, time, isMe];
}
