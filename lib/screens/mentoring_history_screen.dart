import 'package:flutter/material.dart';
import 'chat_history_screen.dart';

class MentoringHistoryScreen extends StatefulWidget {
  const MentoringHistoryScreen({Key? key}) : super(key: key);

  static List<Map<String, dynamic>> mentoringRecords = []; // ✅ 기록 저장 리스트

  @override
  _MentoringHistoryScreenState createState() => _MentoringHistoryScreenState();
}

class _MentoringHistoryScreenState extends State<MentoringHistoryScreen> {
  @override
  void initState() {
    super.initState();
    setState(() {}); // ✅ 기존 기록을 유지하도록 상태 업데이트
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("내 멘토링 기록")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: MentoringHistoryScreen.mentoringRecords.isEmpty
            ? const Center(child: Text("저장된 멘토링 기록이 없습니다."))
            : ListView.builder(
          itemCount: MentoringHistoryScreen.mentoringRecords.length,
          itemBuilder: (context, index) {
            final record = MentoringHistoryScreen.mentoringRecords[index];
            final String mentorName = record["mentor"];
            final String date = record["date"];
            final String firstMessage = record["question"] ?? "대화 없음";
            final List<String> chatHistory =
            record["full_chat"] != null ? record["full_chat"].split("\n") : [];
            final String reflection = record["reflection"] ?? "";

            return Card(
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    title: Text(firstMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text("$mentorName · $date"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      if (chatHistory.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatHistoryScreen(
                              mentorName: mentorName,
                              mentorImage: "assets/images/default.png",
                              messages: chatHistory,
                              date: date,
                              reflection: reflection,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("저장된 대화가 없습니다.")),
                        );
                      }
                    },
                  ),

                  // ✅ 회고 내용을 펼칠 수 있는 슬라이드 위젯 추가
                  if (reflection.isNotEmpty)
                    ExpansionTile(
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
