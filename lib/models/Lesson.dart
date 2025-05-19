/* Tu Quang Chuong thuc hien
4.1.5: Flutter nhận dữ liệu JSON và giải mã.*/

class Lesson {
  final int lessonId;
  final String title;
  final String? description;
  final String? content;
  final String? audioUrl;
  final String? imageUrl;
  final String? level;
  final DateTime? createdAt;
  final int? adminId;

  Lesson({
    required this.lessonId,
    required this.title,
    this.description,
    this.content,
    this.audioUrl,
    this.imageUrl,
    this.level,
    this.createdAt,
    this.adminId,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonId: json['lessonId'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
      audioUrl: json['audioUrl'],
      imageUrl: json['imageUrl'],
      level: json['level'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      adminId: json['adminId'],
    );
  }
}