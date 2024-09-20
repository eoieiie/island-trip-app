import 'package:flutter/material.dart';

class CustomerServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('고객센터'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('문의처',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,  // 글씨 두껍게
                      fontSize: 24,                 // 글씨 크기
                      fontFamily: 'Pretendard',          // 글씨체 변경 (폰트 패밀리)
                    ),
                  ),
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => FaqDetailScreen(question: '자주 묻는 질문 1'),
                  //     ),
                  //   );
                  // },
                ),
                ListTile(
                  title: Text('atropic159@naver.com',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,  // 글씨 두껍게
                      fontSize: 18,                 // 글씨 크기
                      fontFamily: 'Pretendard',          // 글씨체 변경 (폰트 패밀리)
                    ),),
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => FaqDetailScreen(question: '자주 묻는 질문 2'),
                  //     ),
                  //   );
                  // },
                ),
                // 더 많은 FAQ 항목 추가 가능
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // 고객 문의 버튼 클릭 시의 처리
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactUsScreen(),
                  ),
                );
              },
              child: Text('고객 문의'),
            ),
          ),
        ],
      ),
    );
  }
}

// FAQ 상세 화면
class FaqDetailScreen extends StatelessWidget {
  final String question;

  FaqDetailScreen({required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ 상세'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(question), // 실제 FAQ 내용
      ),
    );
  }
}

// 고객 문의 화면
class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('고객 문의'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '이름',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: '이메일',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: '문의 내용',
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 문의 내용 제출 시의 처리
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('문의가 제출되었습니다.')),
                );
              },
              child: Text('제출하기'),
            ),
          ],
        ),
      ),
    );
  }
}
