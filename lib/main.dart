import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Mentoring',
      theme: ThemeData(
        primaryColor: Colors.green,
        fontFamily: 'Pretendard', // 한글 폰트 추가 가능
      ),
      home: const HomeScreen(),
    );
  }
}
