import 'package:flutter/material.dart';
import '../widgets/piano_keyboard.dart';

class PianoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Piano'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tìm hiểu về đàn Piano',
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nhấn vào từng phím đàn để nghe âm thanh và tìm hiểu về các nốt nhạc',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Piano cơ bản',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Piano là nhạc cụ phím có dây được gõ, phát ra âm thanh khi người chơi nhấn các phím trên bàn phím. '
                    'Mỗi phím kết nối với một búa, khi được nhấn, búa sẽ đánh vào dây bên trong piano tạo ra âm thanh.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Các nốt nhạc cơ bản',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Có 7 nốt nhạc cơ bản trong âm nhạc: Đô (C), Rê (D), Mi (E), Fa (F), Sol (G), La (A), và Si (B). '
                    'Những nốt này được thể hiện bằng các phím trắng trên đàn piano. '
                    'Phím đen thể hiện các nốt thăng (#) hoặc giáng (b).',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
            
            // Đàn Piano tương tác
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: PianoKeyboard(),
            ),
            
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Text(
                    'Hướng dẫn thực hành',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  _buildPracticeStep('1. Nhấn vào từng phím đàn để nghe âm thanh'),
                  _buildPracticeStep('2. Xem thông tin chi tiết về từng nốt nhạc'),
                  _buildPracticeStep('3. Tìm hiểu mối quan hệ giữa các nốt nhạc'),
                  _buildPracticeStep('4. Thử chơi theo một giai điệu đơn giản'),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPracticeStep(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.music_note, size: 18),
          SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
} 