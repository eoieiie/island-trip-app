import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:project_island/section/login/view/splash.dart'; // MainScreen 불러오기
import 'package:project_island/firebase_options.dart'; // Firebase 옵션 불러오기

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // WidgetsFlutterBinding 초기화
  await dotenv.load(fileName: ".env"); // .env 파일 로드
  await NaverMapSdk.instance.initialize(
    clientId: dotenv.env['NAVER_MAP_CLIENT_ID']!,
    onAuthFailed: (e) {
      print('네이버맵 인증오류: $e');
    },
  );// 네이버 지도 SDK 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  KakaoSdk.init(nativeAppKey: 'f7f5aa7d9be3f42d6274a97fd8e92bab');
  runApp(MyApp()); // MyApp 위젯을 실행합니다.
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(), // MainScreen을 초기 화면으로 설정
    );
  }
}
