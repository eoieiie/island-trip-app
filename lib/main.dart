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
import 'package:project_island/section/post/views/post_home.dart';
import 'binding/init_binding.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:project_island/section/login/view/splash.dart';
import 'package:project_island/firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
//
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // WidgetsFlutterBinding 초기화

  await dotenv.load(fileName: ".env"); // .env 파일 로드

  await NaverMapSdk.instance.initialize(
    clientId: dotenv.env['NAVER_MAP_CLIENT_ID']!,
    onAuthFailed: (e) {
    },
  ); // 네이버 지도 SDK 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_API_KEY']);

  Get.put(Repository()); // Repository 인스턴스 등록
  Get.put(IslandDetailViewModel(Get.find<Repository>())); // IslandDetailViewModel 인스턴스 등록
  await Hive.initFlutter();
  runApp(MyApp()); // MyApp 위젯을 실행합니다.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitBinding(),
      title: 'Island Travel App',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        primarySwatch: Colors.blue,
        canvasColor: Colors.white,
        cardColor: Colors.white,
        primaryColor: Colors.white,
        colorScheme: const ColorScheme.light(
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

  const MainPage({this.selectedIndex = 0});

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
    //SavedView(),
    PostHomePage(),
    MyPageView(),
  ];

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      body: SafeArea(
        bottom: false,
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
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
            shape: const CircularNotchedRectangle(),
            notchMargin: 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/icon-home-mono.svg',
                    color: _selectedIndex == 0 ? const Color(0xFF1BB874) : const Color(0xFFC8C8C8),
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
                    color: _selectedIndex == 1 ? const Color(0xFF1BB874) : const Color(0xFFC8C8C8),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
                const SizedBox(width: 40),
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/icon-stack-up-square-mono.svg',
                    color: _selectedIndex == 3 ? const Color(0xFF1BB874) : const Color(0xFFC8C8C8),
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
                    color: _selectedIndex == 4 ? const Color(0xFF1BB874) : const Color(0xFFC8C8C8),
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
        shape: const CircleBorder(),
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