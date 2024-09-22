import 'package:flutter/material.dart';
import 'package:project_island/section/common/google_api/views/google_search_page.dart';
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
import 'package:hive_flutter/hive_flutter.dart';

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
  await Hive.initFlutter();
  runApp(MyApp()); // MyApp 위젯을 실행합니다.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitBinding(),
      title: 'Island Travel App',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        primarySwatch: Colors.blue,
        canvasColor: Colors.white,
        cardColor: Colors.white,
        primaryColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: Colors.white, // 주요 색상
          secondary: Colors.blue, // 보조 색상
        ),
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
    HomeView(),
    MyTravelView(),
    HomeMapView(),
    SavedView(),
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
      key: UniqueKey(),
      body: SafeArea(
        bottom: false,
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
              ),
            ],
          ),
          child: BottomAppBar(
            padding: EdgeInsets.zero,
            height: 65,
            shape: CircularNotchedRectangle(),
            notchMargin: 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/icon-home-mono.svg',
                    color: _selectedIndex == 0 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/icon_calendar.svg',
                    color: _selectedIndex == 1 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
                SizedBox(width: 40),
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/icon-stack-up-square-mono.svg',
                    color: _selectedIndex == 3 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                  },
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/icon-user-mono.svg',
                    color: _selectedIndex == 4 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 4;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeMapView()),
          );
        },
        child: SvgPicture.asset(
          'assets/images/mapIcon.svg',
          fit: BoxFit.contain,
          width: 52,
          height: 52,
        ),
        backgroundColor: Colors.white,
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(offsetY: -7),
    );
  }
}

// Custom Floating Action Button Location class
class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final double offsetY; // Y축 조정을 위한 변수

  CustomFloatingActionButtonLocation({this.offsetY = 0});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // X 좌표는 화면 중앙, Y 좌표는 기본 위치에서 offsetY 만큼 아래로
    double fabX = (scaffoldGeometry.scaffoldSize.width - scaffoldGeometry.floatingActionButtonSize.width) / 2;
    double fabY = scaffoldGeometry.scaffoldSize.height - scaffoldGeometry.floatingActionButtonSize.height - 16 + offsetY;
    return Offset(fabX, fabY);
  }
}