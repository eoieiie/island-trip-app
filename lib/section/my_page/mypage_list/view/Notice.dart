import 'package:flutter/material.dart';

class NoticeScreen extends StatelessWidget {
  // 공지사항 데이터 리스트
  final List<String> notices = [
    "앱 업데이트 안내",
    "서버 점검 공지",
    "새로운 기능 추가 안내",
    "기타 공지사항"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공지사항'),
      ),
      body: ListView.builder(
        itemCount: notices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notices[index]),
            onTap: () {
              // 공지사항 클릭 시 상세 화면으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoticeDetailScreen(notice: notices[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// 공지사항 상세 화면
class NoticeDetailScreen extends StatelessWidget {
  final String notice;

  NoticeDetailScreen({required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공지사항 상세'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(notice), // 실제 공지사항 내용
      ),
    );
  }
}
