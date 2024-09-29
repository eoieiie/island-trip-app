import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Future<auth.User?> signInWithKakao() async {
    try {
      OAuthToken token;

      // 카카오톡 설치 여부 확인
      if (await isKakaoTalkInstalled()) {
        try {
          // 카카오톡으로 로그인 시도
          token = await UserApi.instance.loginWithKakaoTalk();

        } catch (error) {
          print('$error');

          // 사용자가 로그인을 취소한 경우
          if (error is PlatformException && error.code == 'CANCELED') {
            return null;
          }

          // 카카오톡 로그인 실패 시, 카카오 계정으로 로그인 시도
          try {
            token = await UserApi.instance.loginWithKakaoAccount();
          } catch (error) {
            print('$error');
            return null;
          }
        }
      } else {
        // 카카오톡이 설치되어 있지 않은 경우, 카카오 계정으로 로그인
        try {
          token = await UserApi.instance.loginWithKakaoAccount();
        } catch (error) {
          print('$error');
          return null;
        }
      }

      // Firebase 인증 제공업체 설정
      var provider = auth.OAuthProvider('oidc.kakao');
      var credential = provider.credential(
        idToken: token.idToken, // 카카오에서 발급된 idToken
        accessToken: token.accessToken, // 카카오에서 발급된 accessToken
      );

      // Firebase 인증으로 사용자 로그인 처리
      final auth.UserCredential userCredential = await _auth.signInWithCredential(credential);

      // 로그인된 사용자 정보를 Firebase에서 가져옴
      final auth.User? user = userCredential.user;

      // Firebase 로그인 성공 및 사용자 정보 출력
      if (user != null) {
        await _printUserInfo(user);  // 로그인 성공 후 사용자 정보를 바로 출력
      }

      // 로그인된 사용자 정보를 반환
      return user;
    } catch (error) {
      print('$error');
      return null;
    }
  }

  Future<void> kakaoSignOut() async {
    try {
      // 카카오 로그아웃 처리
      await UserApi.instance.logout();

      // Firebase 로그아웃 처리
      await _auth.signOut();
    } catch (error) {
      print('$error');
    }
  }

  auth.User? kakaoGetCurrentUser() {
    try {
      // 현재 로그인된 사용자 반환
      return _auth.currentUser;
    } catch (error) {
      print('$error');
      return null;
    }
  }

  // 사용자 정보를 콘솔에 출력하는 함수
  Future<void> _printUserInfo(auth.User user) async {
    // Firebase 사용자 정보 출력
    print('--- Firebase User Info ---');
    print('UID: ${user.uid}');
    print('Email: ${user.email}');
    print('Display Name: ${user.displayName}');
    print('Photo URL: ${user.photoURL}');
    print('Phone Number: ${user.phoneNumber}');
    print('Provider ID: ${user.providerData.map((info) => info.providerId).join(', ')}');
    print('--------------------------');

    // 카카오 사용자 정보 요청 및 출력
    try {
      User kakaoUser = await UserApi.instance.me();
      print('--- Kakao User Info ---');
      print('회원번호: ${kakaoUser.id}');
      print('닉네임: ${kakaoUser.kakaoAccount?.profile?.nickname}');
      print('이메일: ${kakaoUser.kakaoAccount?.email}');
      print('프로필이미지: ${kakaoUser.kakaoAccount?.profile?.profileImageUrl}');
      print('썸네일이미지: ${kakaoUser.kakaoAccount?.profile?.thumbnailImageUrl}');
      print('--------------------------');
    } catch (error) {
      print('카카오 사용자 정보 요청 실패: $error');
    }
  }
}
