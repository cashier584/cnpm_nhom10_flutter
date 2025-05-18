import 'package:flutter/material.dart';

/*Tu Quang Chuong thuc hien */

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
