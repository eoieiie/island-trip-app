import 'dart:math'; // Random 클래스를 사용하기 위해 math 패키지 가져오기
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 라이브러리를 가져오기
import 'package:get/get.dart'; // GetX 라이브러리 가져오기

import 'package:project_island/section/my_page/view/profile_edit_view.dart'; // 프로필 편집 화면 가져오기
import 'package:project_island/section/my_page/view/setting_view.dart'; // 설정 화면 가져오기
import 'package:project_island/section/feed/view/photo_detail_view.dart'; // 사진 상세보기 화면 가져오기

import 'package:project_island/section/my_travel/view/travel_schedule_view.dart'; // 여행 일정 화면 가져오기
import 'package:project_island/section/my_travel/view/island_selection_view.dart'; // 섬 선택 화면 가져오기

import 'package:project_island/section/my_travel/viewmodel/my_travel_viewmodel.dart'; // 여행 뷰모델 가져오기

import 'package:intl/intl.dart'; // 날짜 포맷 라이브러리 가져오기
import 'package:project_island/section/my_travel/model/my_travel_model.dart'; // 여행 모델 가져오기

// MyPageView 위젯의 상태를 관리하는 StatefulWidget입니다.
class MyPageView extends StatefulWidget {
  @override
  _MyPageViewState createState() => _MyPageViewState();
}

// _MyPageViewState 클래스는 MyPageView의 상태를 관리
class _MyPageViewState extends State<MyPageView> {
  List<List<int>> groupBox = [[], [], []]; // 3개의 빈 리스트로 이루어진 groupBox 리스트 생성
  List<int> groupIndex = [0, 0, 0]; // 3개의 0으로 초기화된 groupIndex 리스트 생성

  int _selectedIndex = 0; // 선택된 페이지 인덱스를 저장
  PageController _pageController = PageController(); // 페이지 전환을 위한 컨트롤러

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

  // 하단 네비게이션 아이템이 탭될 때 호출되는 함수
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 선택된 인덱스를 업데이트
    });
    _pageController.jumpToPage(index); // 해당 페이지로 이동
  }

  // 프로필 편집 페이지로 이동하는 함수입니다.
  void _goToProfileEditPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileEditView()), // 프로필 편집 페이지로 이동
    );
  }

  // 설정 페이지로 이동하는 함수입니다.
  void _goToSettingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingView()), // 설정 페이지로 이동
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0), // 상하 패딩 설정
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 끝에 정렬
                children: [
                  GestureDetector(
                    onTap: _goToProfileEditPage, // 프로필 편집 페이지로 이동
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0), // 여백 설정
                          child: CircleAvatar(
                            radius: 30, // 원형 아바타 반지름 설정
                            backgroundColor: Colors.grey, // 배경색 설정
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                          children: [
                            Text(
                              '불금엔제주턱시도', // 사용자 이름
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // 텍스트 스타일 설정
                            ),
                            Text(
                              '한 줄 소개', // 사용자 소개
                              style: TextStyle(fontSize: 14, color: Colors.grey), // 텍스트 스타일 설정
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios), // 오른쪽 화살표 아이콘
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.settings), // 설정 아이콘
                    onPressed: _goToSettingPage, // 설정 페이지로 이동
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white, // 배경색 설정
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, // 공간을 균등하게 배분
                children: [
                  IconButton(
                    icon: Icon(Icons.photo, color: _selectedIndex == 0 ? Colors.blue : Colors.black), // 선택된 상태에 따른 색상 변경
                    onPressed: () {
                      _onItemTapped(0); // 첫 번째 아이템 선택
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.card_giftcard, color: _selectedIndex == 1 ? Colors.blue : Colors.black), // 선택된 상태에 따른 색상 변경
                    onPressed: () {
                      _onItemTapped(1); // 두 번째 아이템 선택
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 2,
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: _selectedIndex == 0 ? Colors.blue : Colors.transparent,
                      height: 2,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: _selectedIndex == 1 ? Colors.blue : Colors.transparent,
                      height: 2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: [
                  LeftPage(),
                  RightPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// LeftPage 위젯입니다.
class LeftPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        childAspectRatio: 1,
      ),
      itemCount: 15,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey[300],
          child: Center(
            child: Text(index % 2 == 0 ? '사진' : '영상'),
          ),
        );
      },
    );
  }
}

// RightPage 위젯입니다.
class RightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20, // 예제용 아이템 수
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('여행 일정 $index'), // 아이템 텍스트 설정
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TravelScheduleView(
                  selectedIsland: '제주도', // 예제용 선택된 섬 이름
                  startDate: DateTime.now(), // 예제용 시작 날짜
                  endDate: DateTime.now().add(Duration(days: 5)), travelId: '', // 예제용 종료 날짜
                ),
              ),
            );
          },
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyPageView(),
  ));
}
