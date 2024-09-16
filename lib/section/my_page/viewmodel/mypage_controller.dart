import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:project_island/section/login/model/login_model.dart' as google_auth;
import 'package:project_island/section/login/model/kakao_login.dart' as kakao_auth;

class MyPageController extends GetxController {
  var profileImagePath = 'assets/images/noUserImage.png'.obs; // 프로필 이미지 URL
  var userName = ''.obs; // 사용자 이름

  var userDescription = '낭만 넘치는 여행을 좋아합니다람쥐.'; // 사용자 한 줄 소개
  int remainingPoints = 180; // 목표까지 남은 포인트
  int currentPoints = 156; // 현재 포인트
  int targetPoints = 1000; // 목표 포인트

  @override
  void onInit() {
    super.onInit();
    loadUserName(); // 사용자 이름을 로드하는 함수 호출
    // 인증 상태 변화를 감지하여 사용자 이름 업데이트
    auth.FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        updateUserName(user.displayName ?? '');
      } else {
        clearUserData();
      }
    });
  }

  // Firebase로부터 로그인된 사용자 이름을 가져와서 업데이트하는 메서드
  void loadUserName() {
    final user = auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      updateUserName(user.displayName ?? '');
      print('로그인된 사용자 이름: ${user.displayName}');// 사용자의 이름이 null일 수 있으므로 기본값으로 빈 문자열을 설정
    } else {
      clearUserData(); // 로그아웃 상태일 경우 사용자 데이터를 초기화
    }
    update();
  }

  // 프로필 이미지 경로 로드 (앱 내부에서 불러오기)
  /*
  void loadProfileImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final profileImageFile = File('${directory.path}/profile_image.png');
    print('Directory Path: ${directory.path}');
    if (profileImageFile.existsSync()) {
      profileImagePath.value = profileImageFile.path; // 기존 이미지 경로 설정
    } else {
      profileImagePath.value = 'assets/images/noUserImage.png'; // 기본 이미지 경로 설정
    }
    update();
  }
   */


  // 기본 프로필 이미지로 설정
  /*
  Future<void> setDefaultProfileImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final profileImageFile = File('${directory.path}/profile_image.png');
    if (profileImageFile.existsSync()) {
      profileImageFile.deleteSync(); // 기존 이미지 삭제
    }
    profileImagePath.value = 'assets/images/noUserImage.png'; // 기본 이미지로 변경
  }
   */

  /*
  // 갤러리에서 이미지 선택 후 앱 내부에 저장
  Future<void> pickImageFromGallery() async {
    // 갤러리 권한 요청
    if (await Permission.storage.request().isGranted) {
      // 권한이 허용된 경우 이미지 선택
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      print("Saved image path: ${profileImagePath.value}");
      if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final profileImageFile = File('${directory.path}/profile_image.png');

        if (profileImageFile.existsSync()) {
          profileImageFile.deleteSync();
          print("Saved image path: ${profileImagePath.value}");
        }

        final newImage = File(pickedFile.path);
        final savedImage = await newImage.copy('${directory.path}/profile_image.png');

        profileImagePath.value = savedImage.path;
        print("Saved image path: ${profileImagePath.value}");
      }
    }
  }
  */

  // 이미지 선택
  /*
  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final profileImageFile = File('${directory.path}/profile_image.png');

      // 새로 선택한 이미지를 기존 경로에 덮어쓰기
      final newImage = File(pickedFile.path);
      final savedImage = await newImage.copy(profileImageFile.path);

      // 이미지 경로 업데이트
      profileImagePath.value = savedImage.path;

      // 경로가 제대로 업데이트 되었는지 확인하는 로그
      print("Updated image path: ${profileImagePath.value}");
    } else {
      print("No image selected.");
    }
  }

   */

  // 사용자 타이틀을 반환하는 getter
  String get userTitle {
    if (currentPoints < 500) {
      return '자라는 나무'; // 500포인트 미만
    } else if (currentPoints < 1000) {
      return '등대지기'; // 500~999포인트
    } else {
      return '탐험가'; // 1000포인트 이상
    }
  }

  // 프로필 이미지 선택 및 업로드



  // 사용자 이름 업데이트
  void updateUserName(String name) {
    userName.value = name;
    update(); // 상태 업데이트
  }

  void clearUserData() {
    userName.value = ''; // 사용자 이름 초기화
    print("사용자 이름 초기화");
    update(); // 상태 업데이트
  }


// 사용자 한 줄 소개 업데이트
/*
  void updateUserDescription(String description) {
    userDescription = description;
    update(); // 상태 업데이트
  }
  */
}