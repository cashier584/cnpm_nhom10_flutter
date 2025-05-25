import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

class FlashcardScreen extends StatefulWidget {
  final String token;

  const FlashcardScreen({required this.token, Key? key}) : super(key: key);

  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  List<dynamic> flashcards = [];
  int currentIndex = 0;
  bool isFrontVisible = true;
  bool isLoading = true;
  bool isPlayingAudio = false;
  String errorMessage = '';
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlayingAudio = state == PlayerState.playing;
      });
    });
  }

  Future<void> _loadFlashcards() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/flashcards'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        setState(() {
          flashcards = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load flashcards: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Connection error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _flipCard() async {
    setState(() {
      isFrontVisible = !isFrontVisible;
    });

    if (!isFrontVisible && flashcards[currentIndex]['audioUrl'] != null) {
      try {
        await audioPlayer.play(UrlSource(flashcards[currentIndex]['audioUrl']));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not play audio: ${e.toString()}')),
        );
      }
    }
  }

  void _nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % flashcards.length;
      isFrontVisible = true;
    });
    audioPlayer.stop();
  }

  void _prevCard() {
    setState(() {
      currentIndex = currentIndex == 0 ? flashcards.length - 1 : currentIndex - 1;
      isFrontVisible = true;
    });
    audioPlayer.stop();
  }

  Widget _buildFlashcardContent() {
    final card = flashcards[currentIndex];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (card['imageUrl'] != null)
          Image.network(
            card['imageUrl'],
            height: 150,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              );
            },
            errorBuilder: (_, __, ___) => Icon(Icons.broken_image, size: 50),
          ),
        SizedBox(height: 20),
        Text(
          isFrontVisible ? card['question'] : card['answer'],
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        if (!isFrontVisible && card['explanation'] != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              card['explanation'],
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
        if (isPlayingAudio)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.volume_up, color: Colors.blue),
                SizedBox(width: 8),
                Text('Đang phát audio...'),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard Nhạc Lý'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: flashcards.isEmpty ? 0 : (currentIndex + 1) / flashcards.length,
            ),
            SizedBox(height: 10),
            Text('${currentIndex + 1}/${flashcards.length}'),

            // Main flashcard content
            Expanded(
              child: Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : errorMessage.isNotEmpty
                    ? Text(errorMessage, style: TextStyle(color: Colors.red))
                    : GestureDetector(
                  onTap: _flipCard,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return RotationTransition(
                        turns: Tween(begin: 0.5, end: 1.0).animate(animation),
                        child: child,
                      );
                    },
                    child: Card(
                      key: ValueKey<bool>(isFrontVisible),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.6,
                        padding: EdgeInsets.all(24),
                        child: _buildFlashcardContent(),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Navigation buttons
            if (!isLoading && errorMessage.isEmpty && flashcards.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _prevCard,
                      child: Text('Trước'),
                    ),
                    ElevatedButton(
                      onPressed: _nextCard,
                      child: Text('Tiếp'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}