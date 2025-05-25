import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Lesson.dart';
import '../models/PianoNoteModel.dart';
import '../widgets/piano_keyboard.dart';
import '../services/piano_service.dart';

/*Tu Quang Chuong thuc hien
4.1.10: Hiển thị nội dung chi tiết bài học đã chọn. */

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;
  
  LessonDetailScreen({required this.lesson});
  
  @override
  _LessonDetailScreenState createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  List<PianoNoteModel> lessonNotes = [];
  bool isLoadingNotes = false;
  String? error;
  
  @override
  void initState() {
    super.initState();
    _fetchLessonPianoNotes();
  }
  
  Future<void> _fetchLessonPianoNotes() async {
    setState(() {
      isLoadingNotes = true;
    });
    
    try {
      final notes = await PianoService.fetchLessonPianoNotes(widget.lesson.lessonId);
      setState(() {
        lessonNotes = notes;
        isLoadingNotes = false;
      });
    } catch (e) {
      setState(() {
        error = 'Lỗi khi lấy dữ liệu nốt nhạc: $e';
        isLoadingNotes = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lesson.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị nội dung bài học
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.lesson.imageUrl != null)
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(widget.lesson.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  SizedBox(height: 16),
                  Text(
                    widget.lesson.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.lesson.description ?? '',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.lesson.content ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                  if (widget.lesson.audioUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.music_note),
                              SizedBox(width: 8),
                              Text('Audio: ${widget.lesson.audioUrl}'),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.play_arrow),
                                onPressed: () {
                                  // Implement audio playback here
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Hiển thị đàn piano và nốt nhạc
            Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Thực hành với đàn piano',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            
            if (isLoadingNotes)
              Center(child: CircularProgressIndicator())
            else if (error != null)
              Center(child: Text(error!))
            else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: PianoKeyboard(lessonId: widget.lesson.lessonId),
              ),
          ],
        ),
      ),
    );
  }
}