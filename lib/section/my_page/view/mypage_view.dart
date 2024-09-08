import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_island/section/my_page/viewmodel/mypage_controller.dart';
import 'package:project_island/section/my_page/mypage_list/view/Cutomer Service.dart';
import 'package:project_island/section/my_page/mypage_list/view/Notice.dart';
import 'package:project_island/section/my_page/view/profile_edit_view.dart';
import 'package:project_island/section/my_page/view/setting_view.dart';
import 'package:project_island/section/login/model/login_model.dart' as google_auth;
import 'package:project_island/section/login/model/kakao_login.dart' as kakao_auth;
import '../../login/view/login_view.dart';

class MyPageView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 20,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
          ),),
        backgroundColor: Colors.white,

        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.grey[400],),
            onPressed: () {
              Get.to(() => SettingView()); // 설정 페이지로 이동
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // 전체 배경 색상 흰색으로 설정
      body: GetBuilder<MyPageController>(
        init: MyPageController(),
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
              backgroundImage: controller.profileImagePath.value.contains('assets')
                  ? AssetImage(controller.profileImagePath.value) as ImageProvider
                  : FileImage(File(controller.profileImagePath.value)),
              onBackgroundImageError: (_, __) async {
                // 오류 발생 시 기본 이미지로 교체
                await controller.setDefaultProfileImage();
              },
            );
          }),
        ),
        // 수정 버튼
        Positioned(
          left: 40, // 버튼을 프로필 이미지 오른쪽 하단에 배치하기 위한 위치 조정
          top: 60, // 프로필 이미지 하단에 위치하도록 조정
          child: GestureDetector( // GestureDetector로 변경
            onTap: () {
              // 버튼을 클릭했을 때 실행될 함수
              log('프로필 수정 버튼 클릭됨', name: 'UserProfileSection');
              print('프로필 수정 버튼 클릭됨');

              showProfileEditOptions(context, controller);
            },
            child: Container(
              width: 24, // 버튼 크기 설정 (좀 더 크게 변경)
              height: 24,
              decoration: BoxDecoration(
                color: Colors.blue, // 버튼 배경 색상
                shape: BoxShape.circle, // 동그란 버튼
                border: Border.all(color: Colors.white, width: 2), // 흰색 테두리
              ),
              child: Icon(
                Icons.edit, // 수정 아이콘
                color: Colors.white, // 아이콘 색상
                size: 12, // 아이콘 크기
              ),
            ),
          ),
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
              Text(
                controller.userName, // 사용자 이름
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

  // 프로필 수정 옵션 표시
  void showProfileEditOptions(BuildContext context, MyPageController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.person),
                title: Text('기본 프로필 사진으로 변경'),
                onTap: () {
                  controller.setDefaultProfileImage();
                  Navigator.of(context).pop(); // 모달 닫기
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('갤러리에서 사진 선택'),
                onTap: () async {
                  await controller.pickImageFromGallery();
                  Navigator.of(context).pop(); // 모달 닫기
                },
              ),
            ],
          ),
        );
      },
    );
  }
}


// 메뉴 리스트 섹션
class MenuListSection extends StatelessWidget {
  final google_auth.AuthService _googleAuthService = google_auth.AuthService(); // Google AuthService 인스턴스 생성
  final kakao_auth.AuthService _kakaoAuthService = kakao_auth.AuthService(); // Kakao AuthService 인스턴스 생성
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
              await _kakaoAuthService.kakaoSignOut();
            }

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
        ListTile(
          title: Text('회원 탈퇴'),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 15),
          onTap: () {
            // 회원 탈퇴 클릭 시 이벤트 처리
          },
        ),
      ],
    );
  }
}