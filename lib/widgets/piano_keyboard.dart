import 'package:flutter/material.dart';
import 'dart:async';
// Import html conditionally
import 'dart:js' as js;
import '../models/PianoNoteModel.dart';
import '../services/piano_service.dart';

class PianoKeyboard extends StatefulWidget {
  final int? lessonId;
  
  const PianoKeyboard({Key? key, this.lessonId}) : super(key: key);
  
  @override
  _PianoKeyboardState createState() => _PianoKeyboardState();
}

class _PianoKeyboardState extends State<PianoKeyboard> {
  // Map to track which notes are currently being played
  final Map<int, bool> notePlayingState = {};
  List<PianoNoteModel> pianoNotes = [];
  bool isLoading = true;
  String? error;
  bool infoModeEnabled = false; // New state variable to track mode

  @override
  void initState() {
    super.initState();
    _loadPianoNotes();
  }

  Future<void> _loadPianoNotes() async {
    try {
      List<PianoNoteModel> notes;
      
      // If lessonId is provided, load notes for that specific lesson
      if (widget.lessonId != null) {
        notes = await PianoService.fetchLessonPianoNotes(widget.lessonId!);
      } else {
        // Otherwise load all notes with sound
        notes = await PianoService.fetchPianoNotesWithSound();
      }
      
      // Sort notes by position if available
      notes.sort((a, b) {
        if (a.position != null && b.position != null) {
          return a.position!.compareTo(b.position!);
        }
        return 0;
      });
      
      setState(() {
        pianoNotes = notes;
        isLoading = false;
      });
      
      print('Loaded ${notes.length} piano notes');
      for (var note in notes) {
        print('Note: ${note.noteLabel} (${note.noteName}), Sound URL: ${note.soundUrl}');
      }
    } catch (e) {
      setState(() {
        error = 'Lỗi kết nối: $e';
        isLoading = false;
      });
      print('Error loading piano notes: $e');
    }
  }

  Future<void> playNote(PianoNoteModel note) async {
    // Toggle note highlight state with more pronounced animation
    setState(() {
      notePlayingState[note.noteId] = true;
    });
    
    // After a short delay, reset the note highlight state
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          notePlayingState[note.noteId] = false;
        });
      }
    });
    
    // Use the centralized PianoService method for playback
    try {
      await PianoService.playPianoNote(
        note,
        onError: (errorMessage) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Không thể phát âm thanh nốt ${note.noteLabel}: $errorMessage'),
                duration: Duration(seconds: 1),
              ),
            );
          }
        }
      );
    } catch (e) {
      print('Lỗi khi phát nốt nhạc: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error!));
    }
    
    if (pianoNotes.isEmpty) {
      return Center(child: Text('Không có dữ liệu nốt nhạc'));
    }

    // Tách nốt trắng và nốt đen
    final whiteNotes = pianoNotes.where((note) => !note.noteName.contains('#')).toList();
    final blackNotes = pianoNotes.where((note) => note.noteName.contains('#')).toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Các nốt nhạc piano',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Add toggle button for switching modes
            Switch(
              value: infoModeEnabled,
              onChanged: (value) {
                setState(() {
                  infoModeEnabled = value;
                });
              },
              activeColor: Colors.blue,
              activeTrackColor: Colors.lightBlue.shade200,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.shade300,
            ),
          ],
        ),
        // Mode description text
        Text(
          infoModeEnabled 
              ? 'Chế độ thông tin (nhấn để xem chi tiết nốt)' 
              : 'Chế độ chơi (nhấn để nghe âm thanh)',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
        ),
        SizedBox(height: 10),
        Container(
          height: 200,
          child: Stack(
            children: [
              // Nốt trắng
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: whiteNotes.map((note) {
                  return _buildWhiteKey(note);
                }).toList(),
              ),

              // Nốt đen
              if (blackNotes.isNotEmpty)
                Positioned(
                  left: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _buildBlackKeysWithSpacing(blackNotes),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          infoModeEnabled 
              ? 'Nhấn vào nốt nhạc để xem thông tin chi tiết' 
              : 'Nhấn vào nốt nhạc để nghe âm thanh',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
  
  Widget _buildWhiteKey(PianoNoteModel note) {
    bool isPlaying = notePlayingState[note.noteId] ?? false;
    
    return GestureDetector(
      onTap: () {
        // In info mode, show note info; in play mode, just play sound
        if (infoModeEnabled) {
          _showNoteInfo(note);
        }
        // Always play the note in both modes
        playNote(note);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        width: 50,
        height: 200,
        decoration: BoxDecoration(
          color: isPlaying ? Colors.grey.shade300 : Colors.white,
          border: Border.all(
            color: isPlaying ? Colors.blue : Colors.black, 
            width: isPlaying ? 2.0 : 1.0
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
          boxShadow: isPlaying 
            ? [] 
            : [BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 2)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              note.noteLabel,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPlaying ? Colors.blue : Colors.black,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBlackKeysWithSpacing(List<PianoNoteModel> blackNotes) {
    // If we have no black notes, return an empty list
    if (blackNotes.isEmpty) {
      return [];
    }
    
    // Ensure we have enough black notes
    if (blackNotes.length < 5) {
      // Create a simplified set of black keys if we don't have enough
      List<Widget> keys = [];
      
      // Standard spacings for a piano octave
      List<double> spacings = [25, 25, 50, 25, 25]; // C#, D#, gap, F#, G#, A#
      
      for (int i = 0; i < 5; i++) {
        if (i < blackNotes.length) {
          keys.add(Container(width: spacings[i]));
          keys.add(_buildBlackKey(blackNotes[i]));
        } else {
          // Add placeholder for missing black keys
          keys.add(Container(width: spacings[i]));
          keys.add(Container(width: 30, height: 120));
        }
      }
      
      return keys;
    }
    
    return [
      Container(width: 25), // Khoảng cách cho nốt C#
      _buildBlackKey(blackNotes[0]), // C#
      Container(width: 25), // Khoảng cách
      _buildBlackKey(blackNotes[1]), // D#
      Container(width: 50), // Khoảng cách lớn hơn (không có E#)
      _buildBlackKey(blackNotes[2]), // F#
      Container(width: 25), // Khoảng cách
      _buildBlackKey(blackNotes[3]), // G#
      Container(width: 25), // Khoảng cách
      _buildBlackKey(blackNotes[4]), // A#
    ];
  }

  Widget _buildBlackKey(PianoNoteModel note) {
    bool isPlaying = notePlayingState[note.noteId] ?? false;
    
    return GestureDetector(
      onTap: () {
        // In info mode, show note info; in play mode, just play sound
        if (infoModeEnabled) {
          _showNoteInfo(note);
        }
        // Always play the note in both modes
        playNote(note);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        width: 30,
        height: 120,
        decoration: BoxDecoration(
          color: isPlaying ? Colors.grey.shade700 : Colors.black,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
          border: isPlaying ? Border.all(color: Colors.blue, width: 2.0) : null,
          boxShadow: isPlaying 
            ? [] 
            : [BoxShadow(color: Colors.black45, offset: Offset(0, 2), blurRadius: 2)],
        ),
      ),
    );
  }
  
  void _showNoteInfo(PianoNoteModel note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(note.noteLabel),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nốt: ${note.noteName}'),
              Text('Quãng tám: ${note.noteOctave}'),
              SizedBox(height: 8),
              Text(note.description),
              if (note.lesson != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Bài học: ${note.lesson!.title}'),
                ),
              if (note.imageUrl != null) 
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Image.network(
                    note.imageUrl!.startsWith('http') 
                      ? note.imageUrl! 
                      : 'http://localhost:8080${note.imageUrl}',
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Không thể tải hình ảnh: $error');
                    },
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up resources
    try {
      js.context.callMethod('eval', ['window.pianoAudioContext = null;']);
    } catch (e) {
      print('Error clearing audio resources: $e');
    }
    
    super.dispose();
  }
} 