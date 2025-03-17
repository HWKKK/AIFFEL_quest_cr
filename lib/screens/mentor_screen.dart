import 'package:flutter/material.dart';
import 'chat_screen.dart';

class MentorScreen extends StatelessWidget {
  final String mentorName;
  final String mentorImage;
  final String mentorId; // 🔥 mentorId 추가
  final String categoryTitle; // 선택한 관심 분야

  const MentorScreen({
    super.key,
    required this.mentorName,
    required this.mentorImage,
    required this.mentorId, // 🔥 mentorId 추가
    required this.categoryTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),

            // 뒤로 가기 버튼
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),

            // "시간을 초월한 ~ 찾았어요!" + 폭죽 아이콘
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text(
                    "\n\n시간을 초월한\n당신만의 멘토를 찾았어요!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/icons/firework.png',
                  width: 150,
                  height: 150,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 멘토 카드 UI
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "$mentorName 멘토님",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/$mentorImage',
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text("이미지를 찾을 수 없습니다.");
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "$categoryTitle을 배우는 과정",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // 🔥 채팅 화면으로 이동할 때 mentorId를 전달!
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(mentorId: mentorId),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("시작하기", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
