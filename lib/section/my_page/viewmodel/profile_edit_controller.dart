import 'package:flutter/material.dart'; // Flutter UI 패키지
import 'package:get/get.dart'; // GetX 패키지
import 'package:project_island/section/my_page/model/user_model.dart'; // IUser 모델 클래스
import 'package:project_island/section/my_page/repository/user_repository.dart'; // UserRepository 클래스

class ProfileEditController extends GetxController {
  var profileImage = ''.obs; // 프로필 이미지 URL
  var isNicknameValid = false.obs; // 닉네임 유효성 상태
  var isChanged = false.obs; // 변경사항 여부
  var isPasswordVisible = false.obs; // 비밀번호 가시성 상태

  TextEditingController nicknameController = TextEditingController(); // 닉네임 입력 컨트롤러
  TextEditingController descriptionController = TextEditingController(); // 한 줄 소개 입력 컨트롤러
  TextEditingController emailController = TextEditingController(); // 이메일 입력 컨트롤러
  TextEditingController passwordController = TextEditingController(); // 비밀번호 입력 컨트롤러

  @override
  void onInit() {
    super.onInit();
    loadUserProfile(); // 사용자 프로필 로드
  }

  // 사용자 프로필 로드 메서드
  void loadUserProfile() {
    IUser? user = UserRepository.currentUser; // 현재 사용자 정보 가져오기
    if (user != null) {
      nicknameController.text = user.nickname ?? ''; // 닉네임 설정
      descriptionController.text = user.description ?? ''; // 한 줄 소개 설정
      emailController.text = user.email ?? ''; // 이메일 설정
      profileImage.value = user.thumbnail ?? ''; // 프로필 이미지 URL 설정
    }
  }

  // 변경사항 체크 메서드
  void checkChanges() {
    isChanged.value = nicknameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty; // 모든 필드가 비어있지 않으면 변경사항 있음
    isNicknameValid.value = nicknameController.text.length >= 5; // 닉네임이 5자 이상이어야 유효
  }

  // 비밀번호 가시성 토글 메서드
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value; // 비밀번호 가시성 토글
  }

  // 변경사항 저장 메서드
  void saveChanges() async {
    IUser updatedUser = IUser(
      uid: UserRepository.currentUser?.uid,
      nickname: nicknameController.text,
      description: descriptionController.text,
      thumbnail: profileImage.value,
      email: emailController.text,
    );
    bool success = await UserRepository.updateUser(updatedUser); // Firebase에 사용자 정보 업데이트
    if (success) {
      Get.back(); // 변경사항 저장 후 화면 닫기
    } else {
      Get.snackbar('오류', '변경사항 저장 실패'); // 실패 시 알림
    }
  }
}
