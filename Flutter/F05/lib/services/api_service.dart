import 'dart:io';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Platform.isAndroid ? 'http://10.0.2.2:8080' : 'http://127.0.0.1:8080',
  ));

  Future<Map<String, dynamic>> predictJellyfish(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      Response response = await _dio.post('/predict', data: formData);

      return response.data;
    } catch (e) {
      print("❌ API 요청 실패: $e");
      return {"error": "예측 실패"};
    }
  }
}
