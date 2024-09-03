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
          top: 20, // userTitle과 userName 사이의 간격 조정
          child: Container(
            width: 60, // 프로필 이미지의 너비
            height: 60, // 프로필 이미지의 높이
            decoration: ShapeDecoration(
              image: DecorationImage(
                // 프로필 이미지를 사용하는 부분
                image: NetworkImage(controller.profileImageUrl), // 수정 전: controller.profileImageUrl

                fit: BoxFit.fill, // 이미지가 컨테이너에 꽉 차도록 설정
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 2, color: Colors.white), // 흰색 테두리 추가
                borderRadius: BorderRadius.circular(30), // 둥근 테두리 설정 (반지름을 30으로 설정)
              ),
              shadows: [
                BoxShadow(
                  color: Colors.grey[200]!, // 그림자의 색상
                  blurRadius: 20, // 그림자의 흐림 정도
                  offset: Offset(0, 8), // 그림자의 위치 조정
                  spreadRadius: 0, // 그림자의 확산 정도
                )
              ],
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
                crossAxisAlignment: CrossAxisAlignment.center, // userTitle과 profileEditButton을 정렬
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      backgroundColor: Colors.grey[200], // 버튼 배경색을 회색으로 설정
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // 둥근 모서리 설정
                      ),
                      minimumSize: Size(60, 30), // 버튼의 width와 height를 조정
                    ),
                    onPressed: () {
                      Get.to(() => ProfileEditView()); // 프로필 편집 페이지로 이동
                    },
                    child: Text(
                      '프로필 편집',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black, // 텍스트 색상을 검정으로 설정
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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
              Text(controller.userDescription), // 한 줄 소개
            ],
          ),
        ),
      ],
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