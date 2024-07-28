import 'package:flutter/material.dart';
import 'package:project_island/section/my_page/view/profile_edit_view.dart';
import 'package:project_island/section/my_page/view/setting_view.dart';
import 'package:project_island/section/my_travel/view/travel_schedule_view.dart';

// MyPageView 위젯의 상태를 관리하는 StatefulWidget입니다.
class MyPageView extends StatefulWidget {
  @override
  _MyPageViewState createState() => _MyPageViewState();
}

// _MyPageViewState 클래스는 MyPageView의 상태를 관리합니다.
class _MyPageViewState extends State<MyPageView> {
  int _selectedIndex = 0; // 선택된 페이지 인덱스를 저장합니다.
  PageController _pageController = PageController(); // 페이지 전환을 위한 컨트롤러입니다.

  // 하단 네비게이션 아이템이 탭될 때 호출되는 함수입니다.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  // 프로필 편집 페이지로 이동하는 함수입니다.
  void _goToProfileEditPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileEditView()),
    );
  }

  // 설정 페이지로 이동하는 함수입니다.
  void _goToSettingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _goToProfileEditPage,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '불금엔제주턱시도',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '한 줄 소개',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: _goToSettingPage,
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.photo, color: _selectedIndex == 0 ? Colors.blue : Colors.black),
                    onPressed: () {
                      _onItemTapped(0);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.card_giftcard, color: _selectedIndex == 1 ? Colors.blue : Colors.black),
                    onPressed: () {
                      _onItemTapped(1);
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
                  endDate: DateTime.now().add(Duration(days: 5)), // 예제용 종료 날짜
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
