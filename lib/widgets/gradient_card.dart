import 'package:flutter/material.dart';

/*Tu Quang Chuong thuc hien */

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
      onTap: onTap != null ? () => onTap!(context) : null,
      child: Container(
        width: 200,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )
            ),
            Spacer(),
            if (icon != null)
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  child: Icon(icon, size: 20, color: Colors.white),
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
