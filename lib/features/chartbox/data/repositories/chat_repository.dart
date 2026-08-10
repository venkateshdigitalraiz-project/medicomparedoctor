import 'package:medicompare/features/chartbox/data/models/message_model.dart';

class ChatRepository {
  Future<List<MessageModel>> getMessages() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return const [
      MessageModel(
        id: "1",
        message: "Hi Doctor, my periods have been irregular. Is it serious?",
        time: "11:30 am",
        isMe: true,
      ),
      MessageModel(
        id: "2",
        message:
            "Hi! It could be stress or hormones. What symptoms have you noticed?",
        time: "11:35 am",
        isMe: false,
      ),
      MessageModel(
        id: "3",
        message: "My last period was two weeks late and lighter than usual.",
        time: "11:36 am",
        isMe: true,
      ),
      MessageModel(
        id: "4",
        message: "That might be stress-related. Any recent lifestyle changes?",
        time: "11:38 am",
        isMe: false,
      ),
      MessageModel(
        id: "5",
        message: "Yes, I've been stressed and sleeping poorly.",
        time: "11:40 am",
        isMe: true,
      ),
      MessageModel(
        id: "6",
        message:
            "That could explain it. Focus on rest and reducing stress. Let's monitor it and check further if it persists.",
        time: "11:42 am",
        isMe: false,
      ),
    ];
  }
}
