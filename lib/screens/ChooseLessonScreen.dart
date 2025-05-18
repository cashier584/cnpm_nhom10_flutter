import 'package:flutter/material.dart';
import '../models/Lesson.dart';
import '../services/lesson_service.dart';
import 'LessonDetailScreen.dart';

/*Tu Quang Chuong thuc hien */

class ChooseLessonScreen extends StatefulWidget {
  final String token;
  ChooseLessonScreen({required this.token});

  @override
  _ChooseLessonScreenState createState() => _ChooseLessonScreenState();
}

class _ChooseLessonScreenState extends State<ChooseLessonScreen> {
  late Future<List<Lesson>> lessonsFuture;

  @override
  void initState() {
    super.initState();
    lessonsFuture = LessonService.fetchLessons(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chọn bài học')),
      body: FutureBuilder<List<Lesson>>(
        future: lessonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          final lessons = snapshot.data!;
          if (lessons.isEmpty)
            return Center(child: Text('Không có bài học nào.'));
          return ListView.builder(
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return Card(
                child: ListTile(
                  leading: lesson.imageUrl != null
                      ? Image.network(lesson.imageUrl!)
                      : Icon(Icons.music_note),
                  title: Text(lesson.title),
                  subtitle: Text(lesson.description ?? ''),
                  onTap: () async {
                    await LessonService.selectLesson(widget.token, lesson.lessonId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LessonDetailScreen(lesson: lesson),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
