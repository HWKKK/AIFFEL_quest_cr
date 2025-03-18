import 'package:flutter/material.dart';

class ChatHistoryScreen extends StatelessWidget {
  final String mentorName;
  final String mentorImage;
  final List<String> messages;
  final String date;
  final String reflection; // ✅ 회고 내용 추가

  const ChatHistoryScreen({
    Key? key,
    required this.mentorName,
    required this.mentorImage,
    required this.messages,
    required this.date,
    required this.reflection, // ✅ 회고 내용 추가
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$mentorName 멘토링 기록 ($date)")),
      body: Column(
        children: [
          // ✅ 회고 내용을 펼칠 수 있는 슬라이드 위젯 추가
          if (reflection.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ExpansionTile(
                title: const Text(
                  "멘토링 회고 보기",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      reflection,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),

          // ✅ 채팅 메시지 리스트
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final bool isUser = index.isOdd;
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.green[300] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        messages[index],
                        style: TextStyle(
                          fontSize: 16,
                          color: isUser ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
