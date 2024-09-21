import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:project_island/section/my_page/viewmodel/mypage_controller.dart';
import 'package:project_island/section/my_page/mypage_list/view/Cutomer Service.dart';
import 'package:project_island/section/my_page/mypage_list/view/Notice.dart';
import 'package:project_island/section/my_page/view/setting_view.dart';
import 'package:project_island/section/login/model/login_model.dart' as google_auth;
import 'package:project_island/section/login/model/kakao_login.dart' as kakao_auth;
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth 임포트
import 'package:google_sign_in/google_sign_in.dart'; // GoogleSignIn 임포트
import '../../login/view/login_view.dart';
import 'package:project_island/section/my_page/viewmodel/mypage_controller.dart';
import 'package:http/http.dart' as http;

class MyPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '마이페이지',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 20,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.grey[400],
            ),
            onPressed: () {
              Get.to(() => SettingView()); // 설정 페이지로 이동
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // 전체 배경 색상 흰색으로 설정
      body: GetBuilder<MyPageController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserProfileSection(controller: controller), // 프로필 섹션
                SizedBox(height: 20),
                SizedBox(height: 20),
                SizedBox(height: 20),
                MenuListSection(), // 메뉴 리스트 섹션
              ],
            ),
          );
        },
      ),
    );
  }
}

// 사용자 프로필 섹션
class UserProfileSection extends StatelessWidget {
  final MyPageController controller;

  UserProfileSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Positioned으로 프로필 이미지를 배치
        Positioned(
          left: 0,
          top: 20,
          child: Obx(() {
            return CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(controller.profileImagePath.value),
            );
          }),
        ),
        // 프로필 사진 우측에 텍스트와 버튼을 배치
        Padding(
          padding: const EdgeInsets.only(left: 75.0), // 프로필 사진 크기만큼 패딩 추가
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // userTitle과 profileEditButton을 한 줄에 정렬
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                // userTitle과 profileEditButton을 정렬
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black, // 배경색을 검정색으로 설정
                      borderRadius: BorderRadius.circular(5), // 둥근 모서리 설정
                    ),
                    child: Text(
                      controller.userTitle, // '탐험가'와 같은 타이틀
                      style: TextStyle(
                        color: Colors.white, // 텍스트 색상을 흰색으로 설정
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Spacer(), // userTitle을 왼쪽에 고정하고 나머지 공간 확보
                ],
              ),
              SizedBox(height: 10),
              Text(
                controller.userName.value, // 사용자 이름
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
            ],
          ),
        ),
      ],
    );
  }
}

// 메뉴 리스트 섹션
class MenuListSection extends StatelessWidget {
  final google_auth.AuthService _googleAuthService =
  google_auth.AuthService(); // Google AuthService 인스턴스 생성
  final kakao_auth.AuthService _kakaoAuthService =
  kakao_auth.AuthService(); // Kakao AuthService 인스턴스 생성
  final MyPageController _myPageController = MyPageController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        ListTile(
          title: Text('공지사항'),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 15),
          onTap: () {
            Get.to(NoticeScreen());
          },
        ),
        ListTile(
          title: Text('고객센터'),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 15),
          onTap: () {
            Get.to(CustomerServiceScreen());
          },
        ),
        ListTile(
          title: Text('사용 가이드'),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 15),
          onTap: () {
            // 사용 가이드 클릭 시 이벤트 처리
          },
        ),
        ListTile(
          title: Text('로그아웃'),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 15),
          onTap: () async {
            // 로그아웃 클릭 시 이벤트 처리
            final googleUser = _googleAuthService.googleGetCurrentUser();
            final kakaoUser = _kakaoAuthService.kakaoGetCurrentUser();

            if (googleUser != null) {
              await _googleAuthService.googleSignOut();
            } else if (kakaoUser != null) {
              await UserApi.instance.unlink();
              await _kakaoAuthService.kakaoSignOut();
            }

            // 로그아웃 후 로그인 화면으로 이동
            Get.offAll(() => LoginScreen());
          },
        ),
        ListTile(
          title: Text('회원 탈퇴'),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 15),
          onTap: () {
            // 회원 탈퇴 클릭 시 이벤트 처리
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // 필요한 만큼만 공간 차지
                    children: [
                      Text(
                        '정말 회원 탈퇴 하시겠습니까?',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop(); // Modal Bottom Sheet 닫기
                              final currentUser = FirebaseAuth.instance.currentUser;
                              print(currentUser);
                              if (currentUser != null) {
                                final providerData = currentUser.providerData;
                                try {
                                  if (providerData.any((userInfo) => userInfo.providerId == 'google.com')) {
                                    // 구글 유저인 경우
                                    await currentUser.delete();
                                    await _googleAuthService.googleSignOut();
                                  } else if (providerData.any((userInfo) => userInfo.providerId == 'oidc.kakao')) {
                                    // 카카오 유저인 경우
                                    print('step1');
                                    try {
                                      await UserApi.instance.unlink();
                                      await currentUser.delete();
                                      await _kakaoAuthService.kakaoSignOut();
                                      Get.offAll(() => LoginScreen());
                                    } catch (error) {
                                      print('연결 끊기 실패 $error');
                                    }
                                  }
                                } catch (e) {
                                  print('회원 탈퇴 중 오류 발생: $e');
                                }
                              } else {
                                // 로그인된 사용자가 없음
                                print('로그인된 사용자가 없습니다.');
                              }
                            },

                            child: Text('네',
                              style: TextStyle(fontFamily: 'Pretendard',
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black, // 버튼 배경색을 검정색으로 설정
                              foregroundColor: Colors.white, // 버튼 글자색을 흰색으로 설정
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black, // 버튼 배경색을 검정색으로 설정
                              foregroundColor: Colors.white, // 버튼 글자색을 흰색으로 설정
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Modal Bottom Sheet 닫기
                            },
                            child: Text('아니오',
                            style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}