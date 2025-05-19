import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Lesson.dart';

/* Tu Quang Chuong thuc hien 
4.1.2: Gửi GET lấy danh sách bài học.
4.1.8: Gửi POST xác nhận chọn bài học.*/

class LessonService {
  static const String baseUrl = 'http://localhost:8080'; // Đổi thành IP nếu cần


// 4.1.2: Gửi GET lấy danh sách bài học
  static Future<List<Lesson>> fetchLessons(String token) async {
    final response = await http.get(
           Uri.parse('http://localhost:8080/api/lessons'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
     final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Lesson.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load lessons');
    }
  }
// 4.1.8: Gửi POST xác nhận chọn bài học
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