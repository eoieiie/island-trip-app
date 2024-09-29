import 'package:get/get.dart'; // GetX 패키지
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage를 사용하기 위한 패키지
import 'package:project_island/section/my_page/model/user_model.dart'; // IUser 모델 클래스
import 'package:project_island/section/my_page/repository/user_repository.dart'; // UserRepository 클래스
import 'package:project_island/binding/init_binding.dart'; // 초기 바인딩 설정
import 'package:image_picker/image_picker.dart'; // 추가
import 'dart:io'; // 추가


class AuthController extends GetxController {
  static AuthController get to => Get.find();
  Rx<IUser> user = IUser().obs; // 현재 사용자 정보를 저장하는 Observable 변수

  // 로그인 메서드
  Future<IUser?> loginUser(String uid) async {
    var userData = await UserRepository.loginUserByUid(uid); // Firebase Firestore에서 사용자 데이터 가져오기
    if (userData != null) {
      user(userData); // Observable user 변수에 사용자 데이터 설정
      InitBinding.additionalBinding(); // 추가적인 바인딩 설정
    }
    return userData; // 사용자 데이터를 반환
  }

  // 회원가입 메서드
  void signup(IUser signupUser, XFile? thumbnail) async {
    if (thumbnail == null) {
      _submitSignup(signupUser); // 썸네일 이미지가 없는 경우, 사용자 정보를 바로 제출
    } else {
      var task = uploadXFile(thumbnail,
          '${signupUser.uid}/profile.${thumbnail.path.split('.').last}'); // 썸네일 이미지를 업로드하고 UploadTask 반환
      task.snapshotEvents.listen((event) async {
        if (event.bytesTransferred == event.totalBytes &&
            event.state == TaskState.success) {
          var downloadUrl = await event.ref.getDownloadURL(); // 다운로드 URL을 가져옴
          var updatedUserData = signupUser.copyWith(thumbnail: downloadUrl); // 다운로드 URL을 포함한 사용자 정보 생성
          _submitSignup(updatedUserData); // 수정된 사용자 정보 제출
        }
      });
    }
  }

  // XFile을 업로드하는 메서드
  UploadTask uploadXFile(XFile file, String filename) {
    var f = File(file.path);
    var ref = FirebaseStorage.instance.ref().child('users').child(filename);
    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});
    return ref.putFile(f, metadata);
  }

  // 사용자 정보를 제출하는 메서드
  void _submitSignup(IUser signupUser) async {
    var result = await UserRepository.signup(signupUser); // UserRepository를 통해 사용자 정보를 서버에 등록
    if (result) {
      loginUser(signupUser.uid!); // 등록이 성공한 경우 사용자 로그인
    }
  }
}
