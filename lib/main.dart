// lib/main.dart

import 'package:flutter/material.dart';
import 'package:project_island/section/my_travel/view/my_travel_view.dart';
// 다른 섹션들의 import도 필요에 따라 추가

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Island Travel App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    MyTravelView(),
    // 여행 도구 페이지
    Scaffold(body: Center(child: Text('여행 도구 페이지'))),
    // 섬 모양 홈버튼 페이지
    Scaffold(body: Center(child: Text('섬 모양 홈버튼 페이지'))),
    // 피드 페이지
    Scaffold(body: Center(child: Text('피드 페이지'))),
    // 마이페이지
    Scaffold(body: Center(child: Text('마이페이지'))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: '내 일정',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore),
            label: '여행 도구',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '섬 모양 홈버튼',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: '피드',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
