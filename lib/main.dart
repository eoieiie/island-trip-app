// lib/main.dart

import 'package:flutter/material.dart';
import 'package:project_island/section/my_travel/view/my_travel_view.dart';
import 'package:project_island/section/my_page/view/my_page_view.dart';
import 'package:project_island/section/feed/view/feed_view.dart';
import 'package:project_island/section/home/view/home_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // WidgetsFlutterBinding 초기화
  await dotenv.load(fileName: ".env"); // .env 파일 로드
  await NaverMapSdk.instance.initialize(
    clientId: dotenv.env['NAVER_MAP_CLIENT_ID']!,
    onAuthFailed: (e) {
      print('네이버맵 인증오류: $e');
    },
  ); // 네이버 지도 SDK 초기화
  runApp(MyApp()); // MyApp 위젯을 실행합니다.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Island Travel App', // 앱의 제목을 설정합니다.
      theme: ThemeData(
        primarySwatch: Colors.blue, // 앱의 기본 색상을 파란색으로 설정합니다.
      ),
      home: MainPage(), // 앱의 시작 페이지를 MainPage로 설정합니다.
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState(); // 상태를 생성합니다.
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 2; // 현재 선택된 페이지의 인덱스를 저장합니다.

  static List<Widget> _widgetOptions = <Widget>[
    MyTravelView(), // 내 일정 페이지
    Scaffold(body: Center(child: Text('여행 도구 페이지'))), // 여행 도구 페이지
    HomeView(), // 섬 모양 홈버튼 페이지
    FeedView(), // 피드 페이지
    MyPageView(), // 마이페이지
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 선택된 페이지 인덱스를 업데이트합니다.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex), // 선택된 인덱스에 해당하는 페이지를 보여줍니다.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on), // 내 일정 아이콘
            label: '내 일정', // 내 일정 라벨
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore), // 여행 도구 아이콘
            label: '여행 도구', // 여행 도구 라벨
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // 섬 모양 홈버튼 아이콘
            label: '섬 모양 홈버튼', // 섬 모양 홈버튼 라벨
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed), // 피드 아이콘
            label: '피드', // 피드 라벨
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // 마이페이지 아이콘
            label: '마이페이지', // 마이페이지 라벨
          ),
        ],
        currentIndex: _selectedIndex, // 현재 선택된 인덱스를 표시합니다.
        selectedItemColor: Colors.blue, // 선택된 아이템의 색상을 파란색으로 설정합니다.
        unselectedItemColor: Colors.grey, // 선택되지 않은 아이템의 색상을 회색으로 설정합니다.
        onTap: _onItemTapped, // 아이템이 탭될 때 호출되는 콜백 함수입니다.
      ),
    );
  }
}