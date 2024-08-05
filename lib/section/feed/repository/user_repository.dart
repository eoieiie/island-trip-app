import 'dart:convert'; // JSON 변환을 위한 패키지
import 'package:http/http.dart' as http; // HTTP 통신을 위한 패키지
import 'package:project_island/section/my_page/model/user_model.dart'; // IUser 모델 클래스 가져오기

//MySQL/MongoDB 용 예시 코드
class UserRepository {
  static const String apiUrl = 'https://your-backend-server.com/api'; // API 기본 URL

  static Future<IUser?> loginUserByUid(String uid) async {
    // 주어진 uid로 사용자를 로그인하는 메서드
    final response = await http.get(Uri.parse('$apiUrl/users?uid=$uid'));
    // API 호출을 통해 uid에 해당하는 사용자 데이터 요청
    if (response.statusCode == 200) {
      // 요청이 성공한 경우
      final data = jsonDecode(response.body);
      // JSON 데이터를 디코딩
      if (data.isEmpty) {
        // 데이터가 비어있는 경우
        return null; // null 반환
      } else {
        return IUser.fromJson(data[0]);
        // 첫 번째 사용자 데이터를 IUser 객체로 변환하여 반환
      }
    } else {
      // 요청이 실패한 경우
      throw Exception('Failed to load user data');
      // 예외 발생
    }
  }

  static Future<bool> signup(IUser user) async {
    // 사용자 정보를 서버에 등록하는 메서드
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/users'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toMap()),
        // IUser 객체를 JSON으로 변환하여 요청 본문에 추가
      );

      if (response.statusCode == 201) {
        // 사용자 등록이 성공한 경우
        return true; // true 반환
      } else {
        // 실패한 경우
        return false; // false 반환
      }
    } catch (e) {
      // 예외 발생 시
      print(e); // 오류 출력
      return false; // false 반환
    }
  }
}
/*
임시 저장소 구현 예시 코드
import 'dart:convert'; // JSON 변환을 위한 패키지
import 'dart:io'; // 파일 작업을 위한 dart:io 패키지
import 'package:path_provider/path_provider.dart'; // 로컬 파일 경로를 위한 패키지
import 'package:project_island/section/my_page/model/user_model.dart'; // IUser 모델 클래스 가져오기

class UserRepository {
  static Future<String> _getLocalPath() async {
    // 로컬 파일 경로를 가져오는 메서드
    final directory = await getApplicationDocumentsDirectory();
    // 앱의 문서 디렉토리 경로 가져오기
    return directory.path; // 경로 반환
  }

  static Future<File> _getLocalFile() async {
    // 로컬 파일 객체를 가져오는 메서드
    final path = await _getLocalPath(); // 로컬 파일 경로 가져오기
    return File('$path/users.json'); // users.json 파일 객체 반환
  }

  static Future<IUser?> loginUserByUid(String uid) async {
    // 주어진 uid로 사용자를 로그인하는 메서드
    try {
      final file = await _getLocalFile(); // 로컬 파일 객체 가져오기
      final contents = await file.readAsString(); // 파일에서 데이터 읽기
      final List<dynamic> data = jsonDecode(contents); // JSON 데이터 디코딩
      final userData =
          data.firstWhere((user) => user['uid'] == uid, orElse: () => null);
      // uid에 해당하는 사용자 데이터 찾기
      if (userData == null) {
        return null; // null 반환
      } else {
        return IUser.fromJson(userData); // IUser 객체로 변환하여 반환
      }
    } catch (e) {
      // 예외 발생 시
      print(e); // 오류 출력
      return null; // null 반환
    }
  }

  static Future<bool> signup(IUser user) async {
    // 사용자 정보를 로컬에 저장하는 메서드
    try {
      final file = await _getLocalFile(); // 로컬 파일 객체 가져오기
      final contents = await file.readAsString(); // 파일에서 기존 데이터 읽기
      final List<dynamic> data = jsonDecode(contents); // JSON 데이터 디코딩
      data.add(user.toMap()); // 새로운 사용자 데이터 추가
      await file.writeAsString(jsonEncode(data)); // 수정된 데이터 저장
      return true; // true 반환
    } catch (e) {
      // 예외 발생 시
      print(e); // 오류 출력
      return false; // false 반환
    }
  }
}
*/