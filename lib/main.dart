import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'screens/ChooseLessonScreen.dart';

/* Tu Quang Chuong thuc hien */


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
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Widget> cardItems = [
    GradientCard(
      title: "Bài tập",
      icon: Icons.arrow_forward,
      gradientColors: [Colors.purpleAccent, Colors.blueAccent],
    ),
    GradientCard(
      title: "Thử thách",
      imageAsset: "assets/challenge.jpg",
      gradientColors: [Colors.orange, Colors.yellow],
    ),
    GradientCard(
      title: "Đàn Piano",
      imageAsset: "assets/piano.png",
      gradientColors: [Colors.pinkAccent, Colors.lightBlueAccent],
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
                      navButton(Icons.music_note, "Songs", context),
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

  Widget navButton(IconData icon, String label, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == "Learn") {
          // Thay thế bằng màn hình bạn muốn chuyển tới
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChooseLessonScreen(token: "YOUR_TOKEN_HERE"),
            ),
          );
        }
        // Có thể thêm điều hướng cho các label khác nếu muốn
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

class GradientCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? imageAsset;
  final List<Color> gradientColors;

  const GradientCard({
    required this.title,
    this.icon,
    this.imageAsset,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Spacer(),
          if (icon != null)
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.greenAccent,
                child: Icon(icon, size: 20),
              ),
            ),
          if (imageAsset != null)
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(imageAsset!),
              ),
            ),
        ],
      ),
    );
  }
}
