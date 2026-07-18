import 'package:flutter/material.dart';

import '../model/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMe;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 270),
        decoration: BoxDecoration(
          color: isMine ? const Color(0xff601CA3) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: isMine
              ? []
              : [BoxShadow(color: Colors.grey.shade200, blurRadius: 12)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: isMine ? Colors.white : Colors.black87,
                fontSize: 16,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message.time,
              style: TextStyle(
                color: isMine ? Colors.white70 : Colors.grey,
                fontSize: 12,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
