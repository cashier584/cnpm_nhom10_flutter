import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'screens/ChooseLessonScreen.dart';
import 'screens/piano_screen.dart';
import 'widgets/gradient_card.dart';

/* Tu Quang Chuong thuc hien
4.1.1: Người dùng nhấn "Chọn bài học" (nút "Learn" trên sidebar).
*/


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piano Learning App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  final List<GradientCard> cardItems = [
    GradientCard(
      title: "Bài tập",
      icon: Icons.assignment,
      gradientColors: [Colors.purpleAccent, Colors.blueAccent],
    ),
    GradientCard(
      title: "Thử thách",
      icon: Icons.fitness_center,
      gradientColors: [Colors.orange, Colors.yellow],
    ),
    GradientCard(
      title: "Đàn Piano",
      icon: Icons.piano,
      gradientColors: [Colors.pinkAccent, Colors.lightBlueAccent],
      onTap: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PianoScreen()),
        );
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: SafeArea(
        child: Row(
          children: [
            // Sidebar hoặc top bar xoay ngang
            Container(
              width: 100,
              color: Colors.grey,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.yellow,
                    child: Icon(Icons.person, color: Colors.blue),
                  ),
                  Column(
                    children: [
                      navButton(Icons.home, "Home", context),
                      SizedBox(height: 12),
                      navButton(Icons.school, "Learn", context),
                      SizedBox(height: 12),
                      navButton(Icons.music_note, "Piano", context, onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PianoScreen()),
                        );
                      }),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.settings, size: 28),
                      SizedBox(height: 16),
                      Icon(Icons.search, size: 28),
                    ],
                  )
                ],
              ),
            ),

            SizedBox(width: 20),

            // Nội dung chính
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                children: cardItems
                    .map((card) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: card,
                ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget navButton(IconData icon, String label, BuildContext context, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        } else if (label == "Learn") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChooseLessonScreen(token: "YOUR_TOKEN_HERE"),
            ),
          );
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.greenAccent.shade100,
            child: Icon(icon, size: 24),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
