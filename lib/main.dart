import 'package:flutter/material.dart';
import 'package:project_island/section/home/repository/home_repository.dart';
import 'package:project_island/section/home/viewmodel/island_detail_viewmodel.dart';
import 'package:project_island/section/my_travel/view/my_travel_view.dart';
import 'package:project_island/section/my_page/view/mypage_view.dart';
import 'package:project_island/section/home/view/home_view.dart';
import 'package:project_island/section/map/view/homemap_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'binding/init_binding.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_island/section/common/kakao_api/views/search_page.dart';
import 'package:project_island/section/saved/view/saved_view.dart';
import 'package:project_island/section/home/view/island_detail_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:project_island/section/login/view/splash.dart';
import 'package:project_island/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // WidgetsFlutterBinding 초기화

  await dotenv.load(fileName: ".env"); // .env 파일 로드

  await NaverMapSdk.instance.initialize(
    clientId: dotenv.env['NAVER_MAP_CLIENT_ID']!,
    onAuthFailed: (e) {
      print('네이버맵 인증오류: $e');
    },
  ); // 네이버 지도 SDK 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  KakaoSdk.init(nativeAppKey: 'f7f5aa7d9be3f42d6274a97fd8e92bab');

  Get.put(Repository()); // Repository 인스턴스 등록
  Get.put(IslandDetailViewModel(Get.find<Repository>())); // IslandDetailViewModel 인스턴스 등록
  runApp(MyApp()); // MyApp 위젯을 실행합니다.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitBinding(),
      title: 'Island Travel App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // 앱의 시작 페이지를 MainPage로 설정합니다.
    );
  }
}

class MainPage extends StatefulWidget {
  final int selectedIndex;

  MainPage({this.selectedIndex = 0});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  static final List<Widget> _widgetOptions = <Widget>[
    // const FeedView(), // 피드 페이지
    HomeView(), // 섬 모양 홈버튼 페이지
    MyTravelView(), // 내 일정 페이지
    HomeMapView(), // 맵 페이지
    SavedView(), //SearchPage(),
    MyPageView(), // 마이페이지
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
      bottomNavigationBar: Stack(
        children: [
          BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/icon-home-mono.svg', // SVG 이미지 경로
                  width: 24,
                  height: 24,
                  color: _selectedIndex == 0 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
                ),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/icon_calendar.svg', // SVG 이미지 경로
                  // 'assets/images/icon-home-mono.svg', // SVG 이미지 경로
                  width: 24,
                  height: 24,
                  color: _selectedIndex == 1 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
                ),
                label: '일정',
              ),
              BottomNavigationBarItem(
                icon: Container(), // 중앙 버튼은 Stack에서 따로 처리하므로 빈 컨테이너
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/icon-stack-up-square-mono.svg', // SVG 이미지 경로
                  width: 24,
                  height: 24,
                  color: _selectedIndex == 3 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
                ),
                label: '저장',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/icon-user-mono.svg', // SVG 이미지 경로
                  width: 24,
                  height: 24,
                  color: _selectedIndex == 4 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
                ),
                label: '마이페이지',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
          ),Positioned(
            top: -30, // 이 값을 조정하여 중앙 아이콘의 높이를 설정하세요.
            left: MediaQuery.of(context).size.width / 2 - 50, // 아이콘 크기의 절반만큼 왼쪽으로 이동
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeMapView()),
                );

              }, // 중앙 버튼 탭 처리
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    // BoxShadow(
                    // color: Colors.black.withOpacity(0.2),
                    // blurRadius: 8,
                    // offset: Offset(0, 4),
                    // ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/icon_compass.png', // PNG 이미지 경로
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
        clipBehavior: Clip.none, // 상단에 겹치는 아이콘이 잘리지 않도록 설정
      ),
    );
  }
}
