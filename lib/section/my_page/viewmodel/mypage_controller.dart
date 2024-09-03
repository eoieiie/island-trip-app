import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:project_island/section/login/model/login_model.dart' as google_auth;
import 'package:project_island/section/login/model/kakao_login.dart' as kakao_auth;

class MyPageController extends GetxController {
  var profileImageUrl = 'https://example.com/profile.jpg'; // 프로필 이미지 URL
  var userName = '김대한'; // 사용자 이름

  var userDescription = '낭만 넘치는 여행을 좋아합니다람쥐.'; // 사용자 한 줄 소개
  int remainingPoints = 180; // 목표까지 남은 포인트
  int currentPoints = 156; // 현재 포인트
  int targetPoints = 1000; // 목표 포인트



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
  Future<void> selectAndUploadProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);


      // Firebase Storage에 이미지 업로드
      try {
        String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.png';
        Reference storageRef = FirebaseStorage.instance.ref().child('profiles/$fileName');
        UploadTask uploadTask = storageRef.putFile(imageFile);

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // 이미지 URL 업데이트
        updateProfileImageUrl(downloadUrl);
      } catch (e) {
        print('이미지 업로드 실패: $e');
      }
    }
  }



  // 사용자 이름 업데이트
  void updateUserName(String name) {
    userName = name;
    update(); // 상태 업데이트
  }

  // 사용자 한 줄 소개 업데이트
  void updateUserDescription(String description) {
    userDescription = description;
    update(); // 상태 업데이트
  }


  // 프로필 이미지 업데이트
  void updateProfileImageUrl(String url) {
    profileImageUrl = url;
    update(); // 상태 업데이트
  }
}
