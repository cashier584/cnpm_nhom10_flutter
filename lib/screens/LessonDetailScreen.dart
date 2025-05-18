import 'package:flutter/material.dart';
import '../models/Lesson.dart';

/*Tu Quang Chuong thuc hien */

class LessonDetailScreen extends StatelessWidget {
  final Lesson lesson;
  LessonDetailScreen({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (lesson.imageUrl != null)
              Image.network(lesson.imageUrl!),
            SizedBox(height: 12),
            Text(lesson.description ?? '', style: TextStyle(fontSize: 16)),
            SizedBox(height: 12),
            Text(lesson.content ?? '', style: TextStyle(fontSize: 14)),
            if (lesson.audioUrl != null)
              Text('Audio: ${lesson.audioUrl}'),
          ],
        ),
      ),
    );
  }
}