import 'package:flutter/material.dart';
import 'package:project_island/section/feed/view/review_write_view.dart';
import 'dart:math'; // Random 클래스를 사용하기 위해 math 패키지 가져오기
import 'package:project_island/section/feed/view/search_focus_view.dart'; // search_focus 파일 가져오기


class FeedView extends StatefulWidget { // FeedView라는 Stateful 위젯 선언
  const FeedView({Key? key}) : super(key: key);

  @override
  State<FeedView> createState() => _FeedViewState(); // 상태 객체 생성
}

class _FeedViewState extends State<FeedView> { // FeedView의 상태 클래스
  List<List<int>> groupBox = [[], [], []]; // 3개의 빈 리스트로 이루어진 groupBox 리스트 생성
  List<int> groupIndex = [0, 0, 0]; // 3개의 0으로 초기화된 groupIndex 리스트 생성

  @override
  void initState() { // 상태 초기화 메서드
    super.initState();
    if (groupIndex.isNotEmpty) { // groupIndex가 비어있지 않으면
      for (var i = 0; i < 100; i++) { // 100번 반복
        var minIndex = groupIndex.indexOf(groupIndex.reduce((value, element) => value < element ? value : element)); // 가장 작은 값을 가진 인덱스 찾기
        var size = 1; // 기본 크기 1로 설정
        if (minIndex != 1) { // 인덱스가 1이 아니면
          size = Random().nextInt(100) % 2 == 0 ? 1 : 2; // 랜덤으로 1 또는 2 할당
        }
        groupBox[minIndex].add(size); // 해당 인덱스에 크기 추가
        groupIndex[minIndex] += size; // 해당 인덱스 크기 업데이트
      }
    }
  }

  Widget _appbar() { // 커스텀 앱바 위젯
    return Column(
      children: [
        Padding( // 상단 패딩과 텍스트
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            '피드', // 앱바 제목
            style: TextStyle(
              color: Colors.grey, // 회색 텍스트 색상
              fontSize: 14, // 텍스트 크기
            ),
          ),
        ),
        Row( // 검색창과 수정 아이콘
          children: [
            Expanded(
              child: GestureDetector( // 검색창 클릭 가능하게 만듦
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchFocus())); // SearchFocus 화면으로 이동
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  margin: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: const Color(0xffefefef), // 배경색
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search), // 검색 아이콘
                      Text(
                        '울릉도', // 검색창 텍스트
                        style: TextStyle(
                          fontSize: 15, // 텍스트 크기
                          color: Color(0xff838383), // 텍스트 색상
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Padding( // 수정 아이콘
              padding: EdgeInsets.all(15.0),
              child: Icon(Icons.edit),
            ),
          ],
        ),
        Row( // 이미지, gif, 지도 아이콘
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.image, color: Colors.black),
            Icon(Icons.gif_box, color: Colors.black),
            Icon(Icons.map, color: Colors.black),
          ],
        )
      ],
    );
  }

  Widget _body() { // 피드 내용 위젯
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate( // 3개의 그룹 생성
          groupBox.length,
              (index) => Expanded(
            child: Column(
              children: List.generate( // 각 그룹에 아이템 생성
                groupBox[index].length,
                    (jndex) => Container(
                  height: groupBox[index][jndex] == 2
                      ? MediaQuery.of(context).size.width * 0.66 // '영상'은 직사각형
                      : MediaQuery.of(context).size.width * 0.33, // '사진'과 'AD'는 정사각형
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // 테두리 설정
                    color: groupBox[index][jndex] == 2 ? Colors.grey : Colors.white, // 색상 설정
                  ),
                  child: Center(
                    child: Text(
                      groupBox[index][jndex] == 1
                          ? (index == 0 ? '사진' : (index == 1 ? '영상' : 'AD')) // 텍스트 설정
                          : '',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ).toList(),
            ),
          ),
        ).toList(),
      ),
    );
  }

  Widget _bottomSheetContent() {
    return Column(
      children: [
        Container(
          height: 30,
          child: Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10, // 예시 데이터 개수
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '제목 $index',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 150,
                      color: Colors.grey[300], // 이미지 공간
                    ),
                    SizedBox(height: 8),
                    Text(
                      '내용 설명 $index',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _mapView(BuildContext context) { // 지도 화면 위젯
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.4, // 화면의 40% 높이
          color: Colors.blue, // 임시로 파란색 배경
          child: Center(
            child: Text('지도 화면', style: TextStyle(color: Colors.white)), // 임시 텍스트
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.6, // 초기 크기
          minChildSize: 0.3, // 최소 크기
          maxChildSize: 1.0, // 최대 크기
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: _bottomSheetContent(),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) { // 빌드 메서드
    return DefaultTabController(
      length: 2, // 탭의 개수
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.gif_box)),
              Tab(icon: Icon(Icons.map)),
            ],
          ),
          title: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '울릉도',
              prefixIcon: Icon(Icons.search),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchFocus())); // SearchFocus 화면으로 이동
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewWriteView())); // ReviewWriteView로 이동
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _body(), // 첫 번째 탭 내용
            _mapView(context), // 두 번째 탭 내용
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FeedView(), // 초기 화면 설정
  ));
}
