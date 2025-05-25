import 'package:cnpm_nhom10_flutter/screens/FlashcardScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'screens/ChooseLessonScreen.dart';

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
  // This would typically come from your authentication system
  final String token = "YOUR_TOKEN_HERE";

  List<Widget> get cardItems => [
    GradientCard(
      title: "Flashcard",
      icon: Icons.style,
      gradientColors: [Colors.purpleAccent, Colors.blueAccent],
      onTap: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FlashcardScreen(token: token),
          ),
        );
      },
    ),
    GradientCard(
      title: "Thử thách",
      imageAsset: "assets/challenge.jpg",
      gradientColors: [Colors.orange, Colors.yellow],
      onTap: (context) {
        // Add navigation for challenge screen if needed
      },
    ),
    GradientCard(
      title: "Đàn Piano",
      imageAsset: "assets/piano.png",
      gradientColors: [Colors.pinkAccent, Colors.lightBlueAccent],
      onTap: (context) {
        // Add navigation for piano screen if needed
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
            // Sidebar
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
                      navButton(Icons.home, "Home", context, onTap: () {
                        // Handle home navigation
                      }),
                      SizedBox(height: 12),
                      navButton(Icons.school, "Learn", context, onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChooseLessonScreen(token: token),
                          ),
                        );
                      }),
                      SizedBox(height: 12),
                      navButton(Icons.music_note, "Songs", context, onTap: () {
                        // Handle songs navigation
                      }),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.settings, size: 28),
                        onPressed: () {
                          // Handle settings
                        },
                      ),
                      SizedBox(height: 16),
                      IconButton(
                        icon: Icon(Icons.search, size: 28),
                        onPressed: () {
                          // Handle search
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),

            SizedBox(width: 20),

            // Main content
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
    return InkWell(
      onTap: onTap,
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
  final Function(BuildContext)? onTap;

  const GradientCard({
    required this.title,
    this.icon,
    this.imageAsset,
    required this.gradientColors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(context),
      child: Container(
        width: 200,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
      ),
    );
  }
}