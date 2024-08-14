import 'dart:io'; // 파일 작업을 위한 dart:io 패키지 가져오기
import 'package:get/get.dart'; // GetX 패키지
import 'package:image_picker/image_picker.dart'; // 이미지 선택을 위한 ImagePicker 패키지
import 'package:path_provider/path_provider.dart'; // 로컬 파일 저장소 경로를 위한 패키지
import 'package:project_island/section/my_page/model/user_model.dart'; // IUser 모델 클래스 가져오기
import 'package:project_island/section/my_page/repository/user_repository.dart'; // UserRepository 클래스 가져오기

// 임시
class AuthController extends GetxController {
  // AuthController 클래스 선언, GetX 컨트롤러 상속
  static AuthController get to => Get.find();
  // AuthController 인스턴스를 찾거나 생성하기 위한 getter

  Rx<IUser> user = IUser().obs;
  // 현재 사용자 정보를 저장하는 Observable 변수

  Future<IUser?> loginUser(String uid) async {
    // 주어진 uid로 사용자를 로그인하는 메서드
    var userData = await UserRepository.loginUserByUid(uid);
    // UserRepository를 통해 uid로 사용자 데이터를 가져옴
    if (userData != null) {
      // 사용자 데이터가 존재하는 경우
      user(userData);
      // Observable user 변수에 사용자 데이터 설정
    }
    return userData;
    // 사용자 데이터를 반환
  }

  void signup(IUser signupUser, XFile? thumbnail) async {
    // 회원가입 메서드, 사용자 정보와 썸네일 이미지를 받음
    if (thumbnail == null) {
      // 썸네일 이미지가 없는 경우
      _submitSignup(signupUser);
      // 사용자 정보를 바로 제출
    } else {
      // 썸네일 이미지가 있는 경우
      var localPath = await saveFileLocally(thumbnail);
      // 썸네일 이미지를 로컬에 저장하고 경로 반환
      if (localPath != null) {
        // 로컬에 저장이 성공한 경우
        var updatedUserData = signupUser.copyWith(thumbnail: localPath);
        // 로컬 경로를 포함한 사용자 정보 생성
        _submitSignup(updatedUserData);
        // 수정된 사용자 정보 제출
      }
    }
  }

  Future<String?> saveFileLocally(XFile file) async {
    // XFile을 로컬에 저장하는 메서드
    try {
      final directory = await getApplicationDocumentsDirectory();
      // 앱의 문서 디렉토리 경로 가져오기
      final localPath = '${directory.path}/${file.name}';
      // 로컬 파일 경로 설정
      final localFile = await File(file.path).copy(localPath);
      // 파일을 로컬 경로로 복사
      return localFile.path;
      // 파일 경로 반환
    } catch (e) {
      // 예외 발생 시
      print(e);
      // 오류 출력
      return null;
      // null 반환
    }
  }

  void _submitSignup(IUser signupUser) async {
    // 사용자 정보를 제출하는 메서드
    var result = await UserRepository.signup(signupUser);
    // UserRepository를 통해 사용자 정보를 서버에 등록
    if (result) {
      // 등록이 성공한 경우
      loginUser(signupUser.uid!);
      // 사용자 로그인
    }
  }
}
/*import 'dart:io'; // 파일 작업을 위한 dart:io 패키지 가져오기
import 'package:get/get.dart'; // GetX 패키지
import 'package:image_picker/image_picker.dart'; // 이미지 선택을 위한 ImagePicker 패키지
import 'package:project_island/section/my_page/model/user_model.dart'; // IUser 모델 클래스 가져오기
import 'package:project_island/section/my_page/repository/user_repository.dart'; // UserRepository 클래스 가져오기
import 'package:http/http.dart' as http; // HTTP 통신을 위한 http 패키지

class AuthController extends GetxController {
  // AuthController 클래스 선언, GetX 컨트롤러 상속
  static AuthController get to => Get.find();
  // AuthController 인스턴스를 찾거나 생성하기 위한 getter

  Rx<IUser> user = IUser().obs;
  // 현재 사용자 정보를 저장하는 Observable 변수

  Future<IUser?> loginUser(String uid) async {
    // 주어진 uid로 사용자를 로그인하는 메서드
    var userData = await UserRepository.loginUserByUid(uid);
    // UserRepository를 통해 uid로 사용자 데이터를 가져옴
    if (userData != null) {
      // 사용자 데이터가 존재하는 경우
      user(userData);
      // Observable user 변수에 사용자 데이터 설정
    }
    return userData;
    // 사용자 데이터를 반환
  }

  void signup(IUser signupUser, XFile? thumbnail) async {
    // 회원가입 메서드, 사용자 정보와 썸네일 이미지를 받음
    if (thumbnail == null) {
      // 썸네일 이미지가 없는 경우
      _submitSignup(signupUser);
      // 사용자 정보를 바로 제출
    } else {
      // 썸네일 이미지가 있는 경우
      var uploadResult = await uploadXFile(thumbnail, '${signupUser.uid}/profile.${thumbnail.path.split('.').last}');
      // 썸네일 이미지를 업로드하고 결과를 반환
      if (uploadResult != null) {
        // 업로드가 성공한 경우
        var updatedUserData = signupUser.copyWith(thumbnail: uploadResult);
        // 다운로드 URL을 포함한 사용자 정보 생성
        _submitSignup(updatedUserData);
        // 수정된 사용자 정보 제출
      }
    }
  }

  Future<String?> uploadXFile(XFile file, String filename) async {
    // XFile을 업로드하는 메서드
    var request = http.MultipartRequest('POST', Uri.parse('https://your-backend-server.com/upload'));
    // 파일 업로드를 위한 POST 요청 생성
    request.files.add(await http.MultipartFile.fromPath('file', file.path, filename: filename));
    // 파일 첨부
    var response = await request.send();
    // 요청 전송
    if (response.statusCode == 200) {
      // 서버가 성공적으로 응답한 경우
      var responseData = await http.Response.fromStream(response);
      // 응답 데이터를 가져옴
      var jsonData = json.decode(responseData.body);
      // JSON 데이터 파싱
      return jsonData['fileUrl'];
      // 파일 URL 반환
    } else {
      return null;
      // 업로드 실패 시 null 반환
    }
  }

  void _submitSignup(IUser signupUser) async {
    // 사용자 정보를 제출하는 메서드
    var result = await UserRepository.signup(signupUser);
    // UserRepository를 통해 사용자 정보를 서버에 등록
    if (result) {
      // 등록이 성공한 경우
      loginUser(signupUser.uid!);
      // 사용자 로그인
    }
  }
}
*/