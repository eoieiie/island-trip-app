import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_island/section/login/model/login_model.dart' as google_auth; // AuthService 불러오기
import 'package:project_island/section/home/view/home_view.dart'; // HomeScreen 불러오기
import 'package:project_island/section/login/view/login_view.dart'; // LoginScreen 불러오기
import 'package:project_island/section/login/model/kakao_login.dart' as kakao_auth;

class MainScreen extends StatelessWidget {
  final google_auth.AuthService _googleAuthService = google_auth.AuthService(); // Google AuthService 인스턴스 생성
  final kakao_auth.AuthService _kakaoAuthService = kakao_auth.AuthService();

  @override
  Widget build(BuildContext context) {
    // 현재 Google로 로그인된 사용자 확인
    User? googleUser = _googleAuthService.googleGetCurrentUser();
    // 현재 Kakao로 로그인된 사용자 확인
    User? kakaoUser = _kakaoAuthService.kakaoGetCurrentUser();

    // Google 또는 Kakao 중 하나라도 로그인된 사용자가 있다면 홈 화면으로 이동
    if (googleUser != null || kakaoUser != null) {
      return HomeView(); // 로그인된 사용자가 있다면 홈 화면으로 이동
    } else {
      return LoginScreen(); // 로그인된 사용자가 없다면 로그인 화면으로 이동
    }
  }
}
