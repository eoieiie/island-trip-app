import 'package:flutter/material.dart';

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl; // 이미지를 받아올 URL

  const FullScreenImagePage({super.key, required this.imageUrl}); // 생성자에 'const'와 'super.key' 추가

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white), // 'const' 추가
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context); // 클릭 시 페이지 닫기
          },
          child: Hero(
            tag: imageUrl, // Hero 애니메이션 태그 설정
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(), // 이미지 로딩 시 표시할 로딩 인디케이터
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 50,
                  ), // 이미지 로딩 실패 시 표시할 아이콘
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
