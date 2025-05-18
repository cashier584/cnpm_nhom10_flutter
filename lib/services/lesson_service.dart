import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Lesson.dart';

/* Tu Quang Chuong thuc hien */

class LessonService {
  static const String baseUrl = 'http://localhost:8080'; // Đổi thành IP nếu cần

  static Future<List<Lesson>> fetchLessons(String token) async {
    final response = await http.get(
           Uri.parse('http://localhost:8080/api/lessons'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Lesson.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load lessons');
    }
  }

  static Future<void> selectLesson(String token, int lessonId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/lessons/select'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: json.encode({'lessonId': lessonId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Chọn bài học thất bại');
    }
  }
}