import 'package:get/get.dart'; // GetX 패키지
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage 패키지
import 'package:image_picker/image_picker.dart'; // 이미지 선택기 패키지
import 'dart:io'; // 파일 작업을 위한 패키지
import 'package:project_island/section/my_page/model/user_model.dart'; // IUser 모델 클래스
import 'package:project_island/section/my_page/repository/user_repository.dart'; // UserRepository 클래스

class MyPageController extends GetxController {
  // 사용자 데이터 변수들
  var profileImageUrl = ''.obs; // Firebase에서 받아올 프로필 이미지 URL
  var userName = ''.obs; // Firebase에서 받아올 사용자 이름
  var userDescription = ''.obs; // Firebase에서 받아올 사용자 한 줄 소개
  var email = ''.obs; // Firebase에서 받아올 이메일
  int remainingPoints = 0; // Firebase에서 받아올 목표까지 남은 포인트
  int currentPoints = 0; // Firebase에서 받아올 현재 포인트
  int targetPoints = 1000; // 목표 포인트 (고정 값)

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

  // 상태에 따라 이미지를 반환하는 메서드
  String get currentIconPath {
    if (currentPoints < 500) {
      return 'assets/images/palm_tree.png'; // 야자수 이미지 경로
    } else if (currentPoints < 1000) {
      return 'assets/images/lighthouse.png'; // 등대 이미지 경로
    } else {
      return 'assets/images/hot_air_balloon.png'; // 열기구 이미지 경로
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadUserData(); // 사용자 데이터 로드
  }

  // 사용자 데이터 로드 메서드
  void _loadUserData() async {
    IUser? user = UserRepository.currentUser; // 현재 로그인된 사용자 정보 가져오기
    if (user != null) {
      userName.value = user.nickname ?? ''; // 사용자 이름 설정
      userDescription.value = user.description ?? ''; // 사용자 한 줄 소개 설정
      profileImageUrl.value = user.thumbnail ?? ''; // 프로필 이미지 URL 설정
      email.value = user.email ?? ''; // 이메일 설정
      currentPoints = user.currentPoints ?? 0; // 현재 포인트 설정
      remainingPoints = targetPoints - currentPoints; // 남은 포인트 계산
    }
  }

  // 포인트가 변경될 때 상태 업데이트
  void updatePoints(int points) {
    currentPoints = points;
    remainingPoints = targetPoints - points;
    update(); // 상태 업데이트
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

        // Firebase에 프로필 이미지 URL 업데이트
        updateProfileImageUrl(downloadUrl);
      } catch (e) {
        print('이미지 업로드 실패: $e');
      }
    }
  }

  // 사용자 이름 업데이트
  void updateUserName(String name) {
    userName.value = name;
    _saveUserData(); // Firebase에 데이터 저장
    update(); // 상태 업데이트
  }

  // 사용자 한 줄 소개 업데이트
  void updateUserDescription(String description) {
    userDescription.value = description;
    _saveUserData(); // Firebase에 데이터 저장
    update(); // 상태 업데이트
  }

  // 프로필 이미지 URL 업데이트
  void updateProfileImageUrl(String url) {
    profileImageUrl.value = url;
    _saveUserData(); // Firebase에 데이터 저장
    update(); // 상태 업데이트
  }

  // Firebase에 사용자 데이터 저장
  void _saveUserData() {
    IUser updatedUser = IUser(
      uid: UserRepository.currentUser?.uid,
      nickname: userName.value,
      description: userDescription.value,
      thumbnail: profileImageUrl.value,
      email: email.value,
      currentPoints: currentPoints, // 현재 포인트 저장
    );
    UserRepository.updateUser(updatedUser); // 사용자 정보 Firebase에 업데이트
  }
}
