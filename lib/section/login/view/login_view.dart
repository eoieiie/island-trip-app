import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_island/section/login/model/login_model.dart' as google_auth; // 구글 로그인용 AuthService
import 'package:project_island/section/login/model/kakao_login.dart' as kakao_auth; // 카카오 로그인용 AuthService
import '../../../main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final google_auth.AuthService _googleAuthService = google_auth.AuthService(); // Google AuthService 인스턴스 생성
  final kakao_auth.AuthService _kakaoAuthService = kakao_auth.AuthService(); // Kakao AuthService 인스턴스 생성

  Future<void> _handleGoogleSignIn() async {
    User? user = await _googleAuthService.signInWithGoogle(); // Google 로그인 시도
    if (user != null) {
      // 로그인 성공 시 홈 화면으로 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage(selectedIndex: 0)),
      );
    }
  }

  Future<void> _handleKakaoSignIn() async {
    User? user = await _kakaoAuthService.signInWithKakao(); // Kakao 로그인 시도
    if (user != null) {
      // 로그인 성공 시 홈 화면으로 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>const MainPage(selectedIndex: 0)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 백그라운드 이미지
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splashImage.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 반투명한 오버레이
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 5),
                Column(
                  children: [
                    const Text(
                      '섬캉스로 떠나는 완벽한 힐링 여행',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/images/isletrip.svg',
                      width: 150,
                      height: 80,
                    ),
                  ],
                ),
                const Spacer(flex: 2),
                Text(
                  'Sign in with Social Networks',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                // 구글 로그인 버튼
                GestureDetector(
                  onTap: _handleGoogleSignIn, // 구글 로그인 처리
                  child: SvgPicture.asset(
                    'assets/images/google_Login.svg',
                  ),
                ),
                const SizedBox(height: 8),
                /*
                // 카카오 로그인 버튼
                GestureDetector(
                  onTap: _handleKakaoSignIn, // 카카오 로그인 처리
                  child: SvgPicture.asset(
                    'assets/images/kakao_Login.svg',
                  ),
                ),

                 */
                const Spacer(flex: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
