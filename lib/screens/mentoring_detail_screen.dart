import 'package:flutter/material.dart';

class MentoringDetailScreen extends StatefulWidget {
  final Map<String, String> session;

  const MentoringDetailScreen({super.key, required this.session});

  @override
  _MentoringDetailScreenState createState() => _MentoringDetailScreenState();
}

class _MentoringDetailScreenState extends State<MentoringDetailScreen> {
  final TextEditingController _reflectionController = TextEditingController();
  String? savedReflection; // 저장된 회고

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.session["mentor"]} 멘토링")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "📌 질문",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            Text(widget.session["question"]!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            Text(
              "💡 멘토의 답변",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const Text(
              "창의적인 사고를 키우기 위해서는 다양한 경험을 하는 것이 중요합니다. "
                  "새로운 관점을 받아들이고, 도전을 두려워하지 마세요.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            Text(
              "✏️ 나의 생각",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
            ),

            // ✅ 회고 기록 입력창
            TextField(
              controller: _reflectionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "멘토의 답변을 듣고, 내 생각을 적어보세요...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),

            // ✅ 회고 저장 버튼
            ElevatedButton(
              onPressed: () {
                setState(() {
                  savedReflection = _reflectionController.text;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("회고가 저장되었습니다!")),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("저장하기", style: TextStyle(color: Colors.white)),
            ),

            if (savedReflection != null) ...[
              const SizedBox(height: 20),
              Text(
                "✅ 저장된 회고",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
              ),
              Text(savedReflection!, style: const TextStyle(fontSize: 16)),
            ],
          ],
        ),
      ),
    );
  }
}
