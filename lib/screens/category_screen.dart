import 'package:flutter/material.dart';
import 'mentor_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int? selectedIndex;

  final List<Map<String, dynamic>> categories = [
    {
      "id": "steven_jobs",  // mentorId 추가
      "title": "창의성과 혁신",
      "icon": Icons.lightbulb,
      "desc": "새로운 아이디어를 찾고 싶어요.",
      "mentor": "스티브 잡스",
      "image": "steven_jobs.webp",
    },
    {
      "id": "john_von_neumann",
      "title": "논리적 사고 & 문제 해결",
      "icon": Icons.psychology,
      "desc": "복잡한 문제를 분석하고 해결책 찾기.",
      "mentor": "존 폰 노이만",
      "image": "john_von_neumann.png",
    },
    {
      "id": "gong_ja",
      "title": "역사적 인물들의 철학",
      "icon": Icons.account_balance,
      "desc": "위대한 사상가들의 지혜 배우기.",
      "mentor": "공자",
      "image": "gong_ja.jpg",
    },
    {
      "id": "huh_jun",
      "title": "웰빙과 균형",
      "icon": Icons.self_improvement,
      "desc": "정신/신체적 건강을 유지하며 성장하기.",
      "mentor": "허준",
      "image": "huh_jun.jpeg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("관심 분야 선택"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("당신이 현재 가장 관심 있는\n분야는 무엇인가요?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.green : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(category["icon"], color: isSelected ? Colors.green : Colors.grey),
                          const SizedBox(width: 15),
                          Text(category["title"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          if (isSelected) const Icon(Icons.check_circle, color: Colors.green),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: selectedIndex != null
                  ? () {
                final selectedCategory = categories[selectedIndex!];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MentorScreen(
                      mentorId: selectedCategory["id"],  // mentorId 추가
                      mentorName: selectedCategory["mentor"],
                      mentorImage: selectedCategory["image"],
                      categoryTitle: selectedCategory["title"],
                    ),
                  ),
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedIndex != null ? Colors.green : Colors.grey,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("다음", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
