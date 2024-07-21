import 'package:flutter/material.dart';
import 'package:project_island/section/my_page/view/profile_edit_view.dart';
import 'package:project_island/section/my_page/view/setting_view.dart';

class MyPageView extends StatefulWidget {
  @override
  _MyPageViewState createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _goToProfileEditPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileEditView()),
    );
  }

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

class RightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('오른쪽 페이지 내용 없음'),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyPageView(),
  ));
}
