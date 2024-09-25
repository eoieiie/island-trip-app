/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_island/section/my_page/viewmodel/profile_edit_controller.dart';
import 'package:project_island/section/my_page/view/upload_view.dart';

// ProfileEditView 클래스는 StatelessWidget을 상속받아 상태가 없는 위젯을 생성
class ProfileEditView extends StatelessWidget {
  // ProfileEditController를 인스턴스화하고 Get.put을 사용하여 DI(의존성 주입)
  final ProfileEditController controller = Get.put(ProfileEditController());

  // build 메서드는 위젯 트리를 생성하여 화면에 표시
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 화면을 터치하면 키보드를 숨김
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true, // 타이틀을 가운데로 정렬
          backgroundColor: Colors.white,
          elevation: 0, // 그림자 없애기
          title: Text('프로필 편집'),
          leading: Padding(
            // leading은 AppBar의 왼쪽에 표시되는 위젯
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Container(
              // Container는 레이아웃을 위한 위젯으로, 내부 위젯을 감싸서 스타일을 적용할 수 있음
              decoration: BoxDecoration(
                // BoxDecoration을 사용해 스타일 적용
                color: Colors.white, // 배경색 흰색
                borderRadius: BorderRadius.circular(12), // 모서리를 둥글게
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3,
                    offset: Offset(0, 0), // 그림자의 위치
                  ),
                ],
              ),
              child: IconButton(
                // IconButton은 버튼 형태로 아이콘을 표시
                icon: Icon(Icons.close, color: Colors.black), // 닫기 아이콘
                onPressed: () {
                  Navigator.pop(context); // 닫기 버튼을 누르면 화면을 닫음
                },
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white, // Scaffold 배경색 흰색
        body: SingleChildScrollView(
          // SingleChildScrollView는 화면이 작을 때 스크롤을 허용
          padding: const EdgeInsets.all(16.0), // 화면 여백 설정
          child: Column(
            // Column 위젯은 수직으로 위젯을 나열
            children: [
              _buildProfilePhoto(context), // 프로필 사진 위젯 생성 함수 호출
              SizedBox(height: 20), // 위젯 사이에 여백 추가
              CustomTextField(
                // 닉네임 입력 필드
                label: '닉네임',
                controller: controller.nicknameController,
                isValid: controller.isNicknameValid.value, // 유효성 검사 상태 전달
                hasValidationIcon: true, // 유효성 검사 아이콘 사용 여부
              ),
              SizedBox(height: 20), // 위젯 사이에 여백 추가
              CustomTextField(
                // 한 줄 소개 입력 필드
                label: '한 줄 소개',
                controller: controller.descriptionController,
              ),
              SizedBox(height: 20), // 위젯 사이에 여백 추가
              CustomTextField(
                // 이메일 입력 필드
                label: '이메일',
                controller: controller.emailController,
              ),
              SizedBox(height: 20), // 위젯 사이에 여백 추가
              CustomTextField(
                // 비밀번호 입력 필드
                label: '비밀번호',
                controller: controller.passwordController,
                isPassword: true, // 비밀번호 입력 필드로 설정
                isVisible: controller.isPasswordVisible.value, // 비밀번호 가시성 설정
                onToggleVisibility: controller.togglePasswordVisibility, // 비밀번호 가시성 토글 함수 전달
              ),
              SizedBox(height: 30), // 위젯 사이에 여백 추가
              Obx(() => ElevatedButton(
                // Obx는 GetX의 상태 관리 기능, 버튼 상태를 동적으로 변경
                onPressed: controller.isChanged.value
                    ? () => controller.saveChanges() // 변경 사항이 있을 때만 저장
                    : null, // 변경 사항이 없으면 버튼 비활성화
                child: Text('저장'), // 버튼 텍스트
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // 버튼 크기 설정
                  backgroundColor: controller.isChanged.value
                      ? Colors.green
                      : Colors.grey[300], // 버튼 색상 설정
                  foregroundColor: Colors.white, // 텍스트 색상 흰색
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  // 프로필 사진 빌드 함수
  Widget _buildProfilePhoto(BuildContext context) {
    return GestureDetector(
      // GestureDetector는 터치 이벤트를 감지
      onTap: () {
        Get.to(() => UploadView()); // 프로필 사진을 클릭하면 업로드 화면으로 이동
      },
      child: Stack(
        // Stack은 위젯을 겹쳐서 배치하는 위젯
        alignment: Alignment.center, // 자식 위젯을 가운데 정렬
        children: [
          Container(
            // 프로필 사진을 감싸는 컨테이너
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                // 테두리를 둥글게
                side: BorderSide(width: 2, color: Color(0x7FFCFCFC)), // 테두리 설정
                borderRadius: BorderRadius.circular(54), // 모서리를 둥글게
              ),
              shadows: [
                BoxShadow(
                  color: Colors.grey[200]!, // 그림자 색상 설정
                  blurRadius: 30, // 그림자 흐림 정도
                  offset: Offset(0, 8), // 그림자 위치
                  spreadRadius: 0, // 그림자 퍼짐 정도
                )
              ],
            ),
            child: CircleAvatar(
              // 프로필 이미지 설정
              radius: 48, // 이미지 크기 설정
              backgroundImage: controller.profileImage.value.isNotEmpty
                  ? NetworkImage(controller.profileImage.value) // 프로필 이미지 URL이 있으면 그 이미지를 표시
                  : null, // 없으면 비어있음
            ),
          ),
          Positioned(
            // 카메라 아이콘을 프로필 사진 오른쪽 하단에 위치
            bottom: 0,
            right: 0,
            child: Container(
              width: 30, // 원형 컨테이너의 가로 크기
              height: 30, // 원형 컨테이너의 세로 크기
              decoration: BoxDecoration(
                shape: BoxShape.circle, // 원형 모양 설정
                color: Colors.white.withOpacity(0.7), // 배경을 반투명한 흰색으로 설정
              ),
              child: Center(
                child: Icon(
                  Icons.camera_alt, // 카메라 아이콘 설정
                  size: 18, // 아이콘 크기 설정
                  color: Colors.green, // 아이콘 색상 설정
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 커스텀 텍스트 필드 위젯
class CustomTextField extends StatelessWidget {
  final String label; // 필드의 레이블(닉네임, 한 줄 소개 등)
  final TextEditingController controller; // 텍스트 입력을 관리하는 컨트롤러
  final bool isPassword; // 비밀번호 필드인지 여부
  final bool isValid; // 유효성 검사 결과
  final bool isVisible; // 비밀번호 가시성 상태
  final bool hasValidationIcon; // 유효성 검사 아이콘을 표시할지 여부
  final VoidCallback? onToggleVisibility; // 비밀번호 가시성 토글 함수

  CustomTextField({
    required this.label, // 필드의 레이블을 설정
    required this.controller, // 텍스트 컨트롤러를 설정
    this.isPassword = false, // 기본적으로 비밀번호 필드가 아님
    this.isValid = true, // 기본적으로 유효성 검사를 통과함
    this.isVisible = true, // 기본적으로 비밀번호가 보임
    this.hasValidationIcon = false, // 기본적으로 유효성 검사 아이콘을 표시하지 않음
    this.onToggleVisibility, // 비밀번호 가시성 토글 함수
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
      children: [
        Text(
          label, // 필드의 레이블을 표시
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold), // 텍스트 스타일 설정
        ),
        SizedBox(height: 5), // 레이블과 텍스트 필드 사이의 간격
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!), // 테두리 색을 연한 회색으로 설정
            borderRadius: BorderRadius.circular(10), // 모서리를 둥글게
          ),
          child: TextField(
            controller: controller, // 텍스트 입력을 관리하는 컨트롤러 설정
            obscureText: isPassword && !isVisible, // 비밀번호 필드일 경우 가시성 설정
            decoration: InputDecoration(
              border: InputBorder.none, // 기본 테두리 제거
              contentPadding:
              EdgeInsets.symmetric(horizontal: 12, vertical: 16), // 내부 패딩
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: onToggleVisibility, // 비밀번호 가시성 토글
              )
                  : hasValidationIcon
                  ? Icon(
                isValid ? Icons.check_circle : Icons.error,
                color: isValid ? Colors.green : Colors.red,
              )
                  : null, // 닉네임 유효성 검사 아이콘 추가
            ),
            onChanged: (value) {
              if (hasValidationIcon) {
                // 유효성 검사 아이콘 상태 변경
                if (label == '닉네임') {
                  controller.text = value; // 닉네임의 유효성을 검사할 때 텍스트를 업데이트
                }
              }
            },
          ),
        ),
      ],
    );
  }
}

 */
