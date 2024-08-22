import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_island/section/my_page//view/profile_edit_view.dart';
import 'package:project_island/section/my_page/view/saved_view.dart';
import 'package:project_island/section/my_page/viewmodel/mypage_controller.dart';
import 'package:confetti/confetti.dart';
import 'package:project_island/section/my_page/view/setting_view.dart';

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
                PointStatusSection(controller: controller), // 포인트 상태 섹션
                SizedBox(height: 20),
                ActivitySection(), // 나의 활동 섹션
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
                image: NetworkImage(controller.profileImageUrl), // Firebase에서 가져온 이미지
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
// 포인트 상태 섹션
class CustomProgressBar extends StatelessWidget {
  final double progress; // 진행률 (0.0 ~ 1.0)
  final int totalPoints; // 총 포인트

  CustomProgressBar({required this.progress, required this.totalPoints});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ProgressBarPainter(progress, totalPoints),
      child: Container(
        height: 3, // 진행 바의 높이
      ),
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  final double progress; //진행률
  final int totalPoints; // 총 포인트

  _ProgressBarPainter(this.progress, this.totalPoints);

  @override
  void paint(Canvas canvas, Size size) {
    // 진행 바 배경
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[100]! //배경 색상을 회색으로 설정
      ..style = PaintingStyle.fill; // 배경 스타일을 채우기로 설정

    // 진행 바 전경
    Paint progressPaint = Paint()
      ..color = Colors.green // 진행된 부분 색상을 초록색으로 설정
      ..style = PaintingStyle.fill; // 전경 스타일을 채우기로 설정

    // 배경 그리기
    Rect backgroundRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(backgroundRect, backgroundPaint);

    // 진행된 부분 그리기
    double progressWidth = size.width * progress;  // 진행된 부분의 너비 계산
    Rect progressRect = Rect.fromLTWH(0, 0, progressWidth, size.height);
    canvas.drawRect(progressRect, progressPaint); // 진행된 부분 그리기

    // 고정된 부표들의 위치 설정
    double leftBuoyPosition = 0; // 왼쪽 부표 위치
    double middleBuoyPosition = size.width / 2; // 중간 부표 위치
    double rightBuoyPosition = size.width; // 오른쪽 부표 위치

    // 부표 색상 설정
    Paint buoyDefaultPaint = Paint()..color = Colors.grey[200]!; // 기본 회색 부표 설정
    Paint buoyActivePaint = Paint()..color = Colors.green; // 활성화된 초록색 부표 설정
    Paint buoyBorderPaint = Paint()..color = Colors.white; // 흰색 테두리 설정

    // 부표 상태에 따라 색상 설정
    Paint leftBuoyPaint = progress >= 0.0 ? buoyActivePaint : buoyDefaultPaint; // 왼쪽 부표 색상 설정
    Paint middleBuoyPaint = progress >= 0.5 ? buoyActivePaint : buoyDefaultPaint; // 중간 부표 색상 설정
    Paint rightBuoyPaint = progress >= 1.0 ? buoyActivePaint : buoyDefaultPaint; // 오른쪽 부표 색상 설정

    // 왼쪽 고정된 부표 그리기 (흰색 테두리 + 부표 색상)
    canvas.drawCircle(Offset(leftBuoyPosition, size.height / 2), 8, buoyBorderPaint); // 흰색 테두리
    canvas.drawCircle(Offset(leftBuoyPosition, size.height / 2), 6, leftBuoyPaint); // 부표

    // 중간 고정된 부표 그리기 (흰색 테두리 + 부표 색상)
    canvas.drawCircle(Offset(middleBuoyPosition, size.height / 2), 8, buoyBorderPaint); // 흰색 테두리
    canvas.drawCircle(Offset(middleBuoyPosition, size.height / 2), 6, middleBuoyPaint); // 부표

    // 오른쪽 고정된 부표 그리기 (흰색 테두리 + 부표 색상)
    canvas.drawCircle(Offset(rightBuoyPosition, size.height / 2), 8, buoyBorderPaint); // 흰색 테두리
    canvas.drawCircle(Offset(rightBuoyPosition, size.height / 2), 6, rightBuoyPaint); // 부표

    // 현재 위치를 나타내는 부표
    double currentBuoyPosition = progressWidth; // 현재 위치 계산

    // 현재 위치 부표 그리기 (흰색 테두리 + 초록색 + 회색 반투명)
    if (currentBuoyPosition > 0) {
      Paint currentBuoyPaint = Paint()..color = Colors.green; // 초록색 부표 설정
      Paint currentBuoyBorderPaint = Paint()..color = Colors.white; // 흰색 테두리 설정
      Paint currentBuoyShadowPaint = Paint()..color = Colors.grey.withOpacity(0.15); // 회색 반투명

      // 회색 반투명 원 그리기 (현재 위치)
      canvas.drawCircle(Offset(currentBuoyPosition, size.height / 2), 18, currentBuoyShadowPaint);

      // 흰색 테두리 그리기 (현재 위치)
      canvas.drawCircle(Offset(currentBuoyPosition, size.height / 2), 8, currentBuoyBorderPaint);

      // 초록색 부표 그리기 (현재 위치)
      canvas.drawCircle(Offset(currentBuoyPosition, size.height / 2), 6, currentBuoyPaint);
    }
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 매번 다시 그리기
  }
}

// 포인트 상태 섹션
class PointStatusSection extends StatelessWidget {
  final MyPageController controller;
  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 1));

  PointStatusSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.currentPoints >= controller.targetPoints) {
      _confettiController.play(); // 목표 포인트 달성 시 애니메이션 실행
    }

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xFFF1F1F1), width: 1), // 테두리 설정
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // '목표까지'와 남은 포인트를 표시하는 RichText를 담은 Container
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5), // 패딩 설정
                decoration: BoxDecoration(
                  color: Colors.black, // 배경색 검정 설정
                  borderRadius: BorderRadius.circular(12), // 둥근 모서리 설정
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '목표까지 ',
                        style: TextStyle(
                          color: Colors.white, // '목표까지' 텍스트는 흰색
                          //fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      TextSpan(
                        text: '${controller.remainingPoints} Point',
                        style: TextStyle(
                          color: Colors.orange, // 남은 포인트는 주황색
                          //fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8), // '목표까지' Container와 포인트 텍스트 사이 간격

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 포인트 텍스트와 이미지가 양 끝에 배치되도록 설정
                children: [
                  // 현재 포인트와 목표 포인트를 보여주는 RichText
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${controller.currentPoints}p ', // 현재 포인트
                          style: TextStyle(
                            color: Colors.black, // 검정색 글씨
                            fontWeight: FontWeight.bold,
                            fontSize: 25, // 더 큰 글씨 크기 설정
                          ),
                        ),
                        TextSpan(
                          text: '/ ${controller.targetPoints}p', // 목표 포인트
                          style: TextStyle(
                            color: Colors.grey, // 회색 글씨
                            fontSize: 16, // 더 작은 글씨 크기 설정
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 현재 상태에 맞는 이미지를 표시
                  Image.asset(
                    controller.currentIconPath,
                    width: 40, // 이미지 너비 설정 (적절한 크기로 설정)
                    height: 40, // 이미지 높이 설정 (적절한 크기로 설정)
                  ),
                ],
              ),

              SizedBox(height: 30), // 이미지와 진행 바 사이 간격 조절

              Row(
                children: [
                  Expanded(
                    child: CustomProgressBar(
                      progress: controller.currentPoints / controller.targetPoints,
                      totalPoints: controller.targetPoints,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30), // 진행 바와 '달성 조건 알아보기' 사이 간격 조절

              Row(
                mainAxisAlignment: MainAxisAlignment.start, // '달성 조건 알아보기'와 아이콘을 Row로 정렬, spaceBetween이면 오른쪽으로 정렬됨
                children: [
                  GestureDetector( // 클릭 가능한 텍스트로 변경
                    onTap: () {
                      // 달성 조건 알아보기 클릭 시 이벤트 처리
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 2,),
                        Text(
                          '달성 조건 알아보기',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(width: 3),

                        Icon(
                          Icons.info_rounded, // 정보 아이콘 추가
                          color: Colors.grey[300], // 아이콘 색상을 회색으로 설정
                          size: 13, // 아이콘 크기 설정
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
            ),
          ),
        ),
      ],
    );
  }
}


// 나의 활동 섹션
class ActivitySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // '나의 활동' 제목 텍스트
        Text(
          ' 나의 활동',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10), // 제목과 버튼들 사이의 간격
        Row(
          children: [
            // '관심 목록' 버튼
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(SavedView());
                  // '관심 목록' 버튼 클릭 시 이벤트 처리
                },
                icon: Icon(Icons.bookmark, color: Colors.orange, size: 18), // 아이콘 색상과 크기 설정
                label: Text(
                  '관심 목록',
                  style: TextStyle(color: Colors.black), // 텍스트 색상을 검정으로 설정
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // 버튼 배경색을 흰색으로 설정
                  side: BorderSide(width: 0.5, color: Color(0xFFF1F1F1)), // 버튼 테두리 색상과 두께 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // 둥근 모서리 설정
                  ),
                ),
              ),
            ),
            SizedBox(width: 10), // 두 버튼 사이의 간격
            // '나의 후기' 버튼
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // '나의 후기' 버튼 클릭 시 이벤트 처리
                },
                icon: Icon(Icons.edit, color: Colors.black, size: 18), // 아이콘 색상과 크기 설정
                label: Text(
                  '나의 후기',
                  style: TextStyle(color: Colors.black), // 텍스트 색상을 검정으로 설정
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // 버튼 배경색을 흰색으로 설정
                  side: BorderSide(width: 0.5, color: Color(0xFFF1F1F1)), // 버튼 테두리 색상과 두께 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // 둥근 모서리 설정
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
// 메뉴 리스트 섹션
class MenuListSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        ListTile(
          title: Text('공지사항'),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 15,),
          onTap: () {
            // 공지사항 클릭 시 이벤트 처리
          },
        ),
        ListTile(
          title: Text('고객센터'),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 15,),
          onTap: () {
            // 고객센터 클릭 시 이벤트 처리
          },
        ),
        ListTile(
          title: Text('사용 가이드'),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 15,),
          onTap: () {
            // 사용 가이드 클릭 시 이벤트 처리
          },
        ),
        ListTile(
          title: Text('로그아웃'),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 15,),
          onTap: () {
            // 로그아웃 클릭 시 이벤트 처리
          },
        ),
        ListTile(
          title: Text('회원 탈퇴'),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 15,),
          onTap: () {
            // 회원 탈퇴 클릭 시 이벤트 처리
          },
        ),
      ],
    );
  }
}
