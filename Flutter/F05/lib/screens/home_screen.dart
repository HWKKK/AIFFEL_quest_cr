import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _selectedImage;
  final picker = ImagePicker();

  String? _jellyfishClass;
  double? _confidence;

  // 📌 이미지 선택 함수
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _jellyfishClass = null;
        _confidence = null;
      });
    }
  }

  // 📌 FastAPI 서버에 이미지 업로드 후 결과 가져오기
  Future<void> _fetchPrediction({required bool fetchClass}) async {
    if (_selectedImage == null) {
      print("⚠️ 먼저 이미지를 선택하세요!");
      await _pickImage();
      if (_selectedImage == null) return; // 사용자가 이미지 선택 안 하면 종료
    }

    final result = await ApiService().predictJellyfish(_selectedImage!);

    setState(() {
      if (fetchClass) {
        _jellyfishClass = result['class']; // ✅ 해파리 클래스만 저장
      } else {
        _confidence = result['confidence']; // ✅ 확률만 저장
      }
    });

    // 디버그 출력
    if (fetchClass) {
      print("🔍 해파리 클래스: $_jellyfishClass");
    } else {
      print("📊 예측 확률: ${(_confidence! * 100).toStringAsFixed(2)}%");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jellyfish Classifier"),
        leading: Icon(Icons.bubble_chart),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ✅ 중앙에 이미지 표시
          _selectedImage != null
              ? Image.file(_selectedImage!, height: 300, width: 300, fit: BoxFit.cover)
              : Text("이미지를 선택하세요", style: TextStyle(fontSize: 18)),

          SizedBox(height: 20),

          // ✅ 해파리 클래스 출력
          if (_jellyfishClass != null)
            Text("🔍 해파리 클래스: $_jellyfishClass", style: TextStyle(fontSize: 18)),

          // ✅ 예측 확률 출력
          if (_confidence != null)
            Text("📊 예측 확률: ${(_confidence! * 100).toStringAsFixed(2)}%", style: TextStyle(fontSize: 18)),

          SizedBox(height: 20),

          // ✅ 버튼 두 개 (Row 정렬)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ 왼쪽 버튼 → 해파리 클래스만 출력
              ElevatedButton.icon(
                icon: Icon(Icons.category),
                label: Text("해파리 예측"),
                onPressed: () => _fetchPrediction(fetchClass: true),
              ),
              SizedBox(width: 20),

              // ✅ 오른쪽 버튼 → 예측 확률만 출력
              ElevatedButton.icon(
                icon: Icon(Icons.percent),
                label: Text("예측 확률"),
                onPressed: () => _fetchPrediction(fetchClass: false),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
