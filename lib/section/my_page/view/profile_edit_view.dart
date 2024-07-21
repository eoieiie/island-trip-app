import 'package:flutter/material.dart';
import 'package:project_island/section/feed/view/add_photo_view.dart'; // add_photo_view 파일 가져오기

class ProfileEditView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('프로필 편집'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPhotoView()), // add_photo_view 페이지로 이동
                );
              },
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.camera_alt, size: 40),
              ),
            ),
            SizedBox(height: 40), // 간격 조정
            TextField(
              decoration: InputDecoration(
                labelText: '닉네임',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: '한 줄 소개',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 40), // 간격 조정
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('변경'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // 버튼 크기 조정
                backgroundColor: Colors.grey[300], // 버튼 배경 색상 조정
                foregroundColor: Colors.black, // 텍스트 색상 조정
              ),
            ),
          ],
        ),
      ),
    );
  }
}