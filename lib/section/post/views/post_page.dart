import 'dart:io';
import 'package:flutter/material.dart';
import '../viewmodels/post_viewmodel.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostViewModel postViewModel = PostViewModel();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  File? _image;

  // 게시글 등록 함수 추출
  void _submitPost() async {
    String title = _titleController.text;
    String content = _contentController.text;
    if (title.isNotEmpty && content.isNotEmpty) {
      // Firestore에 게시글 업로드 등 처리
      await postViewModel.addPost(
        _titleController.text,
        _contentController.text,
        _image,
      );
      Navigator.pop(context); // 작성 완료 후 이전 화면으로
    } else {
      // 입력 값이 없으면 경고 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('제목과 내용을 입력하세요')),
      );
    }
  }

  // 등록 버튼 위젯
  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16), // 하단 여백 추가
      child: Center(
        child: ElevatedButton(
          onPressed: _submitPost,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
            child: Text('등록하기', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1BB874),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  // 입력 필드 디자인 개선
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '커뮤니티 글 작성',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 20,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context); // 뒤로 가기
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목 입력
            Text(" 제목", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
            SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: _inputDecoration(' 제목을 입력하세요'),
              cursorColor: Color(0xFF6699FF),
            ),
            SizedBox(height: 10),
            Divider(
              thickness: 0.5,
              color: Colors.grey[300],
            ),
            // 내용 입력
            Text(" 내용", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
            SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null, // 입력한 내용에 따라 자동으로 줄바꿈
                decoration: _inputDecoration(' 내용을 입력하세요'),
                cursorColor: Color(0xFF6699FF),
              ),
            ),
            // 등록 버튼 배치
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }
}
