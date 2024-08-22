import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_island/section/my_page/model/user_model.dart';
import 'package:project_island/section/my_page/repository/user_repository.dart';

class ProfileEditController extends GetxController {
  var profileImage = ''.obs; // 프로필 이미지 URL
  var isNicknameValid = false.obs; // 닉네임이 유효한지 여부
  var isChanged = false.obs; // 변경사항이 있는지 여부
  var isPasswordVisible = false.obs; // 비밀번호 가시성

  TextEditingController nicknameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadUserProfile(); // 사용자 프로필 로드
  }

  void loadUserProfile() {
    // 현재 사용자 정보를 로드하여 컨트롤러에 설정
    IUser? user = UserRepository.currentUser;
    if (user != null) {
      nicknameController.text = user.nickname ?? '';
      descriptionController.text = user.description ?? '';
      emailController.text = user.email ?? '';
      profileImage.value = user.thumbnail ?? '';
    }
  }

  void checkChanges() {
    // 변경사항 체크
    isChanged.value = nicknameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
    isNicknameValid.value = nicknameController.text.length >= 5;
  }

  void togglePasswordVisibility() {
    // 비밀번호 가시성 토글
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void saveChanges() async {
    // 변경사항 저장 로직
    IUser updatedUser = IUser(
      uid: UserRepository.currentUser?.uid,
      nickname: nicknameController.text,
      description: descriptionController.text,
      thumbnail: profileImage.value,
      email: emailController.text,
    );
    bool success = await UserRepository.updateUser(updatedUser);
    if (success) {
      Get.back(); // 변경사항 저장 후 화면 닫기
    } else {
      Get.snackbar('오류', '변경사항 저장 실패');
    }
  }
}
