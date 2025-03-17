import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class ChatScreen extends StatefulWidget {
  final String mentorId;

  const ChatScreen({Key? key, required this.mentorId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottomButton = false;
  bool lastMessageIsUser = true; // 🔥 마지막 메시지가 사용자 메시지였는지 확인

  // 🔥 멘토 정보
  final Map<String, String> _mentorProfiles = {
    "steven_jobs": "스티브 잡스",
    "john_von_neumann": "존 폰 노이만",
    "gong_ja": "공자",
    "huh_jun": "허준",
  };

  final Map<String, String> _mentorImages = {
    "steven_jobs": "assets/images/steven_jobs.webp",
    "john_von_neumann": "assets/images/john_von_neumann.png",
    "gong_ja": "assets/images/gong_ja.jpg",
    "huh_jun": "assets/images/huh_jun.jpeg",
  };

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset < _scrollController.position.maxScrollExtent - 100) {
        setState(() {
          _showScrollToBottomButton = true;
        });
      } else {
        setState(() {
          _showScrollToBottomButton = false;
        });
      }
    });
  }

  // 🔥 채팅 입력 후 맨 아래로 스크롤
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // 🔥 메시지 전송 함수
  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        "text": _controller.text,
        "isUser": true,
      });
      lastMessageIsUser = true; // ✅ 사용자가 새 질문을 했음
    });

    String userQuestion = _controller.text;
    _controller.clear();

    final uri = Uri.parse("http://10.0.2.2:8000/chat");
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: jsonEncode({
        "mentor_id": widget.mentorId,
        "question": userQuestion,
      }),
    );

    if (response.statusCode == 200) {
      final utf8DecodedBody = utf8.decode(response.bodyBytes);
      final data = json.decode(utf8DecodedBody);
      List<String> responses = List<String>.from(data["responses"]);

      bool firstMessageInGroup = true; // 🔥 새로운 답변 그룹에서 첫 메시지만 프로필 표시

      for (String message in responses) {
        setState(() {
          _messages.add({
            "text": message,
            "isUser": false,
            "showProfile": firstMessageInGroup || lastMessageIsUser, // ✅ 연속된 답변인지 확인하여 프로필 추가
          });
          firstMessageInGroup = false;
        });

        await Future.delayed(const Duration(seconds: 1));
        _scrollToBottom();
      }

      lastMessageIsUser = false; // ✅ 이제 AI가 답변 중
    } else {
      setState(() {
        _messages.add({
          "text": "서버와 연결할 수 없습니다.",
          "isUser": false,
          "showProfile": true, // 오류 메시지는 프로필 표시
        });
      });
    }

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    String mentorName = _mentorProfiles[widget.mentorId] ?? "멘토";
    String mentorImage = _mentorImages[widget.mentorId] ?? "assets/images/default.png";

    return Scaffold(
      appBar: AppBar(title: Text("$mentorName 멘토와의 대화")),
      body: Stack(
        children: [
          Column(
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
                                  mentorName,
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

              // 🔥 채팅 입력창 (여백 추가)
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 8, 12, 40),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "답변하기...",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none, // 테두리 없음
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.green),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 🔥 스크롤 아래로 이동 버튼
          if (_showScrollToBottomButton)
            Positioned(
              bottom: 80,
              right: 10,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.green,
                onPressed: _scrollToBottom,
                child: const Icon(Icons.arrow_downward, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}