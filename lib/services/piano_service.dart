import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import '../models/PianoNoteModel.dart';
import 'dart:js' as js;

class PianoService {
  // Use your actual server address here - you might need to use your machine's local IP instead of localhost for testing on real devices
  static const String baseUrl = 'http://localhost:8080';
  static bool useMockData = false; // Set to false to use real API data

  // Helper method to check if a resource at a URL is accessible
  static Future<bool> isResourceAccessible(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('Resource check failed: $e');
      return false;
    }
  }

  // Fetch all piano notes
  static Future<List<PianoNoteModel>> fetchPianoNotes() async {
    if (useMockData) {
      return _getMockPianoNotes();
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/piano-notes'),
        headers: {
          'Access-Control-Allow-Origin': '*', // Try to bypass CORS
        },
      );

      if (response.statusCode == 200) {
        // Use utf8.decode to handle special characters
        final List<dynamic> notesJson = json.decode(utf8.decode(response.bodyBytes));
        return notesJson.map((json) => PianoNoteModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load piano notes: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock data on error
      print('Error fetching piano notes: $e');
      return _getMockPianoNotes();
    }
  }

  // Fetch piano notes with sound
  static Future<List<PianoNoteModel>> fetchPianoNotesWithSound() async {
    if (useMockData) {
      return _getMockPianoNotes();
    }
    
    try {
      // First try the POST endpoint
      final response = await http.post(
        Uri.parse('$baseUrl/api/piano-notes/with-sound'),
        headers: {
          'Access-Control-Allow-Origin': '*', // Try to bypass CORS
        },
      );

      if (response.statusCode == 200) {
        // Use utf8.decode to handle special characters
        final List<dynamic> notesJson = json.decode(utf8.decode(response.bodyBytes));
        
        // Just return the notes, we don't need to check sound URLs anymore
        List<PianoNoteModel> notes = notesJson.map((json) => PianoNoteModel.fromJson(json)).toList();
        
        return notes;
      } else {
        // If POST fails, try the regular GET endpoint
        return fetchPianoNotes();
      }
    } catch (e) {
      print('Error fetching piano notes with sound: $e');
      // Try the regular GET endpoint as a fallback
      return fetchPianoNotes();
    }
  }

  // Fetch piano notes for a specific lesson
  static Future<List<PianoNoteModel>> fetchLessonPianoNotes(int lessonId) async {
    if (useMockData) {
      return _getMockPianoNotes();
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/piano-notes/lesson/$lessonId'),
        headers: {
          'Access-Control-Allow-Origin': '*', // Try to bypass CORS
        },
      );

      if (response.statusCode == 200) {
        // Use utf8.decode to handle special characters
        final List<dynamic> notesJson = json.decode(utf8.decode(response.bodyBytes));
        return notesJson.map((json) => PianoNoteModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load piano notes for lesson: ${response.statusCode}');
      }
    } catch (e) {
      // Return mock data on error
      print('Error fetching lesson piano notes: $e');
      return _getMockPianoNotes();
    }
  }

  // Mock data for when server is unavailable
  static List<PianoNoteModel> _getMockPianoNotes() {
    return [
      PianoNoteModel(
        noteId: 1,
        noteName: 'C',
        noteLabel: 'Đô',
        noteOctave: '4',
        description: 'Đây là nốt Đô, nốt đầu tiên trong bảng âm.',
        soundUrl: null,
        imageUrl: null,
      ),
      PianoNoteModel(
        noteId: 2,
        noteName: 'D',
        noteLabel: 'Rê',
        noteOctave: '4',
        description: 'Đây là nốt Rê, nốt thứ hai trong bảng âm.',
        soundUrl: null,
        imageUrl: null,
      ),
      PianoNoteModel(
        noteId: 3,
        noteName: 'E',
        noteLabel: 'Mi',
        noteOctave: '4',
        description: 'Đây là nốt Mi, nốt thứ ba trong bảng âm.',
        soundUrl: null,
        imageUrl: null,
      ),
      PianoNoteModel(
        noteId: 4,
        noteName: 'F',
        noteLabel: 'Fa',
        noteOctave: '4',
        description: 'Đây là nốt Fa, nốt thứ tư trong bảng âm.',
        soundUrl: null,
        imageUrl: null,
      ),
      PianoNoteModel(
        noteId: 5,
        noteName: 'G',
        noteLabel: 'Sol',
        noteOctave: '4',
        description: 'Đây là nốt Sol, nốt thứ năm trong bảng âm.',
        soundUrl: null,
        imageUrl: null,
      ),
      PianoNoteModel(
        noteId: 6,
        noteName: 'A',
        noteLabel: 'La',
        noteOctave: '4',
        description: 'Đây là nốt La, nốt thứ sáu trong bảng âm.',
        soundUrl: null,
        imageUrl: null,
      ),
      PianoNoteModel(
        noteId: 7,
        noteName: 'B',
        noteLabel: 'Si',
        noteOctave: '4',
        description: 'Đây là nốt Si, nốt thứ bảy trong bảng âm.',
        soundUrl: null,
        imageUrl: null,
      ),
      PianoNoteModel(
        noteId: 8,
        noteName: 'C#',
        noteLabel: 'Đô#',
        noteOctave: '4',
        description: 'Đây là nốt Đô thăng, nằm giữa Đô và Rê.',
        soundUrl: null,
        imageUrl: null,
      ),
      PianoNoteModel(
        noteId: 9,
        noteName: 'D#',
        noteLabel: 'Rê#',
        noteOctave: '4',
        description: 'Đây là nốt Rê thăng, nằm giữa Rê và Mi.',
        soundUrl: null,
        imageUrl: null,
      ),
      PianoNoteModel(
        noteId: 10,
        noteName: 'F#',
        noteLabel: 'Fa#',
        noteOctave: '4',
        description: 'Đây là nốt Fa thăng, nằm giữa Fa và Sol.',
        soundUrl: null,
        imageUrl: null,
      ),
      PianoNoteModel(
        noteId: 11,
        noteName: 'G#',
        noteLabel: 'Sol#',
        noteOctave: '4',
        description: 'Đây là nốt Sol thăng, nằm giữa Sol và La.',
        soundUrl: null,
        imageUrl: null,
      ),
      PianoNoteModel(
        noteId: 12,
        noteName: 'A#',
        noteLabel: 'La#',
        noteOctave: '4',
        description: 'Đây là nốt La thăng, nằm giữa La và Si.',
        soundUrl: null,
        imageUrl: null,
      ),
    ];
  }
  
  // Simplified method for playing piano notes using only Web Audio API
  static Future<void> playPianoNote(PianoNoteModel note, {Function(String)? onError}) async {
    try {
      // Generate tone with Web Audio API
      _playToneWithWebAudio(note.noteName);
    } catch (e) {
      print('Lỗi khi phát nốt nhạc: $e');
      if (onError != null) {
        onError('Lỗi tổng thể: $e');
      }
    }
  }
  
  // Play a note using Web Audio API
  static void _playToneWithWebAudio(String noteName) {
    try {
      // Calculate frequency based on note name (simplified)
      double frequency = 262.0; // Default C4 (Đô)
      
      switch (noteName) {
        case 'C': frequency = 262.0; break;  // Đô
        case 'C#': frequency = 277.0; break; // Đô#
        case 'D': frequency = 294.0; break;  // Rê
        case 'D#': frequency = 311.0; break; // Rê#
        case 'E': frequency = 330.0; break;  // Mi
        case 'F': frequency = 349.0; break;  // Fa
        case 'F#': frequency = 370.0; break; // Fa#
        case 'G': frequency = 392.0; break;  // Sol
        case 'G#': frequency = 415.0; break; // Sol#
        case 'A': frequency = 440.0; break;  // La
        case 'A#': frequency = 466.0; break; // La#
        case 'B': frequency = 494.0; break;  // Si
      }
      
      // Try to play a tone using JavaScript Web Audio API
      final script = """
        (function() {
          try {
            // Create audio context if it doesn't exist
            if (!window.pianoAudioContext) {
              window.pianoAudioContext = new (window.AudioContext || window.webkitAudioContext)();
            }
            
            var ctx = window.pianoAudioContext;
            var oscillator = ctx.createOscillator();
            var gainNode = ctx.createGain();
            
            // Set up sound
            oscillator.type = 'sine';
            oscillator.frequency.value = $frequency;
            
            // Set envelope for piano-like sound
            gainNode.gain.setValueAtTime(0.7, ctx.currentTime);
            gainNode.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.5);
            
            // Connect and play
            oscillator.connect(gainNode);
            gainNode.connect(ctx.destination);
            
            oscillator.start();
            setTimeout(function() { 
              oscillator.stop(); 
            }, 500);
          } catch(e) {
            console.error('Web Audio API error:', e);
          }
        })();
      """;
      
      js.context.callMethod('eval', [script]);
    } catch (e) {
      print('Không thể phát âm thanh với Web Audio API: $e');
    }
  }
} 