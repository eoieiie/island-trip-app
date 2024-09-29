import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:project_island/section/login/model/login_model.dart' as google_auth;
import 'package:project_island/section/login/model/kakao_login.dart' as kakao_auth;
import 'package:project_island/section/home/viewmodel/home_viewmodel.dart';
import 'package:project_island/section/login/view/login_view.dart';
import '../../../main.dart';
import '../../home/repository/home_repository.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final google_auth.AuthService _googleAuthService = google_auth.AuthService();
  final kakao_auth.AuthService _kakaoAuthService = kakao_auth.AuthService();
  final HomeViewModel homeViewModel = Get.put(HomeViewModel(Repository()));

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Splash 화면에서 API 데이터를 미리 로드
    await _fetchInitialData();

    // 로그인 상태 확인
    User? googleUser = _googleAuthService.googleGetCurrentUser();
    User? kakaoUser = _kakaoAuthService.kakaoGetCurrentUser();

    // 로그인된 사용자가 있으면 MainPage로 이동, 없으면 LoginScreen으로 이동
    if (googleUser != null || kakaoUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Future<void> _fetchInitialData() async {
    // 홈 화면에서 필요한 API 데이터 미리 로드
    await homeViewModel.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // 로딩 중일 때 표시할 UI
      ),
    );
  }
}



/*
  class SplashScreen extends StatelessWidget {
    final google_auth.AuthService _googleAuthService = google_auth.AuthService(); // Google AuthService 인스턴스 생성
    final kakao_auth.AuthService _kakaoAuthService = kakao_auth.AuthService();
    @override
    Widget build(BuildContext context) {
      // Wait for 2 seconds and then decide which page to navigate
      Future.delayed(Duration(seconds: 2), () {
        _navigateToNextScreen(context);
      });

      return Scaffold(
        body: Center(
          child: Text('Splash Screen'), // Replace with your splash UI
        ),
      );
    }

    void _navigateToNextScreen(BuildContext context) async {
      // Check if user is logged in
      User? googleUser = _googleAuthService.googleGetCurrentUser();
      User? kakaoUser = _kakaoAuthService.kakaoGetCurrentUser();

      if (googleUser != null || kakaoUser != null) {
        // User is logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else {
        // User is not logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }
  }

   */