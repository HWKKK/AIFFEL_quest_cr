import 'package:flutter/material.dart';
import 'category_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80), // 위쪽 여백
            const Text(
              "과거와 현재가\n만나는 곳,",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: "당신만의 "),
                  TextSpan(
                    text: "AI 멘토링",
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "당신의 하루를 특별하게 만들어줄\n시간을 초월한 멘토와의 대화",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // 멘토 리스트 (4명)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _mentorIcon("steven_jobs.webp", "스티브 잡스"),
                _mentorIcon("john_von_neumann.webp", "존 폰 노이만"),
                _mentorIcon("gong_ja.webp", "공자"),
                _mentorIcon("huh_jun.webp", "허준"),
              ],
            ),

            const Spacer(), // 버튼을 아래로 밀기
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "멘토 찾으러 떠나기",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _mentorIcon(String imageName, String name) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.black,
          backgroundImage: AssetImage('assets/icons/$imageName'),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        const Text(
          "멘토님",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF868e96), // 옅은 회색
          ),
        ),
      ],
    );
  }
}
