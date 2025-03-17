import 'package:flutter/material.dart';
import 'home_screen.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            const Text(
              "존 폰 노이만님이\n지식의 금쪽린 늑대님에게",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "리워드를 수여하셨습니다!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Image.asset('assets/images/reward_badge.png', height: 150), // 리워드 이미지 추가
            const SizedBox(height: 20),
            const Text("전략적 리더십을 배웠어요!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("2025년 3월 17일", style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // 공유 기능 (나중에 추가 가능)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("공유 기능은 곧 추가됩니다!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("나의 승리 공유하기", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (route) => false, // 모든 이전 화면을 제거하고 홈으로 이동
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("홈 화면으로 돌아가기", style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
