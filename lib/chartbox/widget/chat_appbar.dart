import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(top: 16, left: 8, right: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFEFF6FF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),

          // const CircleAvatar(
          //   radius: 22,
          //   backgroundImage: AssetImage("assets/images/doctor.png"),
          // ),
          const SizedBox(width: 52),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dr. Sarah",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                ),
                Text(
                  "Typing...",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call, color: Colors.green),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam, color: Colors.blue),
          ),

          PopupMenuButton(
            itemBuilder: (_) => const [
              PopupMenuItem(value: 1, child: Text("View Profile")),
              PopupMenuItem(value: 2, child: Text("Block")),
            ],
          ),
        ],
      ),
    );
  }
}
