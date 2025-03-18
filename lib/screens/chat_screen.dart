import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:main_quest/main.dart';
import 'mentoring_history_screen.dart';

class ChatScreen extends StatefulWidget {
  final String mentorId;
  final String mentorName;

  const ChatScreen({Key? key, required this.mentorId, required this.mentorName}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool lastMessageIsUser = true;

  final Map<String, String> _mentorImages = {
    "steven_jobs": "assets/images/steven_jobs.webp",
    "john_von_neumann": "assets/images/john_von_neumann.png",
    "gong_ja": "assets/images/gong_ja.jpg",
    "huh_jun": "assets/images/huh_jun.jpeg",
  };

  String get mentorImage => _mentorImages[widget.mentorId] ?? "assets/images/default.png";


  // ✅ 메시지 전송 함수
  Future<void> _sendMessage() async {
    String userInput = _controller.text.trim();
    if (userInput.isEmpty) return;

    setState(() {
      _messages.add({
        "text": userInput,
        "isUser": true,
      });
    });

    _controller.clear(); // 입력창 초기화

    final uri = Uri.parse("http://10.0.2.2:8000/chat"); // 서버 주소
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: jsonEncode({
        "mentor_id": widget.mentorId,
        "question": userInput,
      }),
    );

    if (response.statusCode == 200) {
      final utf8DecodedBody = utf8.decode(response.bodyBytes);
      final data = json.decode(utf8DecodedBody);
      List<String> responses = List<String>.from(data["responses"]);

      bool firstMessageInGroup = true;

      for (String message in responses) {
        setState(() {
          _messages.add({
            "text": message,
            "isUser": false,
            "showProfile": firstMessageInGroup || lastMessageIsUser,
          });
          firstMessageInGroup = false;
        });

        await Future.delayed(const Duration(seconds: 1));
        _scrollToBottom();
      }

      lastMessageIsUser = false;
    } else {
      setState(() {
        _messages.add({
          "text": "서버 응답을 받을 수 없습니다.",
          "isUser": false,
          "showProfile": true,
        });
      });
    }

    _scrollToBottom();
  }

  // ✅ 채팅 입력 후 맨 아래로 스크롤
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // (1) 대화 기록 저장 다이얼로그
  void _showSaveDialog() {
    TextEditingController reflectionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("대화 기록 저장"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: reflectionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "멘토링 후 느낀 점을 입력하세요",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("취소"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_messages.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("저장할 대화가 없습니다!")),
                  );
                  return;
                }

                // ✅ 먼저 다이얼로그를 닫기 전에 데이터 저장
                setState(() {
                  MentoringHistoryScreen.mentoringRecords.add({
                    "mentor": widget.mentorName,
                    "question": _messages.first["text"],
                    "date": DateTime.now().toString().split(" ")[0],
                    "reflection": reflectionController.text,
                    "full_chat": _messages.map((msg) => msg["text"]).join("\n"),
                  });
                });

                // ✅ 다이얼로그를 닫기 전에 잠시 대기 후 SnackBar 표시
                Future.delayed(const Duration(milliseconds: 200), () {
                  Navigator.pop(context); // 다이얼로그 닫기
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("대화가 저장되었습니다!")),
                  );
                });
              },
              child: const Text("저장"),
            ),
          ],
        );
      },
    );
  }

  // (2) 대화 리셋
  void _resetConversation() {
    setState(() {
      _messages.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("대화가 초기화되었습니다!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.mentorName} 멘토와의 대화"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "save_chat") {
                _showSaveDialog(); // "대화 기록" 다이얼로그 호출
              } else if (value == "reset_chat") {
                _resetConversation(); // "대화 리셋" 호출
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "save_chat", child: Text("대화 기록")),
              const PopupMenuItem(value: "reset_chat", child: Text("대화 리셋")),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final bool isUser = message["isUser"] ?? false;
                final bool showProfile = message["showProfile"] ?? false;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  child: Column(
                    crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      if (!isUser && showProfile) ...[
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(mentorImage),
                              radius: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.mentorName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.green[300] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message["text"],
                          style: TextStyle(
                            fontSize: 16,
                            color: isUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ✅ 채팅 입력창
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "답변하기...",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: _sendMessage, // 메시지 전송 기능 필요
                ),
              ],
            ),
          ),
        ],
      ),

      // ✅ 하단 메뉴바 추가 (채팅 화면에서도 유지)
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "내 멘토링"),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.green,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen()));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MentoringHistoryScreen()));
          }
        },
      ),
    );
  }
}
