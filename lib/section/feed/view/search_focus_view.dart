import 'package:flutter/material.dart'; // Flutter의 Material 디자인 패키지 가져오기

class SearchFocus extends StatefulWidget { // SearchFocus Stateful 위젯 선언
  const SearchFocus({Key? key}) : super(key: key);

  @override
  State<SearchFocus> createState() => _SearchFocusState(); // 상태 객체 생성
}

class _SearchFocusState extends State<SearchFocus> {
  Widget _recentSearch() { // 최근 검색지 위젯
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('최근 검색지'), // 최근 검색지 제목
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(), // 스크롤 비활성화
          itemCount: 2, // 아이템 개수
          itemBuilder: (context, index) {
            return ListTile(
              leading: Container(
                width: 50,
                height: 50,
                color: Colors.grey[300], // 회색 배경
              ),
              title: Text('울릉도 + 카테고리(상) 위치'), // 아이템 제목
              trailing: ElevatedButton(
                onPressed: () {},
                child: Text('선택'), // 선택 버튼
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0), // 패딩 추가
          child: TextButton(
            onPressed: () {},
            child: Text('더 보기'), // 더 보기 버튼
          ),
        ),
      ],
    );
  }

  Widget _popularPlaces() { // 인기 관광지 위젯
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('인기 관광지'), // 인기 관광지 제목
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(), // 스크롤 비활성화
          itemCount: 2, // 아이템 개수
          itemBuilder: (context, index) {
            return ListTile(
              leading: Container(
                width: 50,
                height: 50,
                color: Colors.grey[300], // 회색 배경
              ),
              title: Text('울릉도 + 카테고리(상) 위치'), // 아이템 제목
              trailing: ElevatedButton(
                onPressed: () {},
                child: Text('선택'), // 선택 버튼
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0), // 패딩 추가
          child: TextButton(
            onPressed: () {},
            child: Text('더 보기'), // 더 보기 버튼
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) { // 빌드 메서드
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // 앱바 그림자 제거
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // 뒤로 가기 아이콘
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기 기능
          },
        ),
        title: TextField(
          decoration: InputDecoration(
            border: InputBorder.none, // 테두리 없음
            hintText: '관광지/맛집/놀거리 검색', // 기본 힌트 텍스트
          ),
          onTap: () {
            setState(() {}); // 텍스트 필드 클릭 시 상태 갱신
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search), // 검색 아이콘
            onPressed: () {}, // 검색 버튼 기능 (추후 구현)
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _recentSearch(), // 최근 검색지 위젯 추가
            Divider(), // 구분선 추가
            _popularPlaces(), // 인기 관광지 위젯 추가
          ],
        ),
      ),
    );
  }
}
