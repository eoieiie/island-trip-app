import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'section/my_travel/view/my_travel_view.dart';
import 'section/my_page/view/my_page_view.dart';
import 'section/feed/view/feed_view.dart';
import 'section/home/view/home_view.dart';
import 'section/home/view/magazine_view.dart'; // Import updated
import 'section/home/repository/home_repository.dart';
import 'section/home/viewmodel/magazine_viewmodel.dart'; // Import updated

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await NaverMapSdk.instance.initialize(
    clientId: dotenv.env['NAVER_MAP_CLIENT_ID']!,
    onAuthFailed: (e) {
      print('네이버맵 인증오류: $e');
    },
  );

  // Register the MagazineViewModel
  Get.put(MagazineViewModel(repository: Repository()));

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
  int _selectedIndex = 2;

  static List<Widget> _widgetOptions = <Widget>[
    MyTravelView(),
    Scaffold(body: Center(child: Text('여행 도구 페이지'))),
    MagazineView(), // Ensure correct view
    FeedView(),
    MyPageView(),
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
            label: '매거진', // Ensure correct label
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
