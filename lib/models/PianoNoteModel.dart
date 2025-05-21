import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Lesson.dart';

class PianoNoteModel {
  final int noteId;
  final String noteName;
  final String noteLabel;
  final String noteOctave;
  final String description;
  final String? soundUrl;
  final String? imageUrl;
  final int? position;
  final Lesson? lesson;

  PianoNoteModel({
    required this.noteId,
    required this.noteName,
    required this.noteLabel,
    required this.noteOctave,
    required this.description,
    this.soundUrl,
    this.imageUrl,
    this.position,
    this.lesson,
  });

  factory PianoNoteModel.fromJson(Map<String, dynamic> json) {
    return PianoNoteModel(
      noteId: json['noteId'],
      noteName: json['noteName'],
      noteLabel: json['noteLabel'] ?? '',
      noteOctave: json['noteOctave'] ?? '',
      description: json['description'] ?? '',
      soundUrl: json['soundUrl'],
      imageUrl: json['imageUrl'],
      position: json['position'],
      lesson: json['lesson'] != null ? Lesson.fromJson(json['lesson']) : null,
    );
  }
}