import 'package:flutter/material.dart';
import '../model/home_model.dart';
import '../view/island_detail_view.dart';

class MagazineView extends StatelessWidget {
  final Magazine magazine; // Magazine 객체를 받는 매개변수

  MagazineView({required this.magazine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(magazine.title), // 매거진 제목을 앱바의 타이틀로 설정
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 매거진 썸네일 이미지
              if (magazine.thumbnail.isNotEmpty)
                Image.network(
                  magazine.thumbnail,
                  width: double.infinity,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 16.0),

              // 매거진 제목
              Text(
                magazine.title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),

              // 매거진 설명
              Text(
                magazine.description,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16.0),

              // 매거진 해시태그 목록
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: magazine.hashtags.map((hashtag) {
                  return Chip(
                    label: Text(hashtag),
                    backgroundColor: Colors.green.shade100,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
