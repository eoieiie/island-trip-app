import 'dart:convert'; // JSON 변환을 위한 패키지
import 'package:http/http.dart' as http; // HTTP 통신을 위한 패키지
import 'package:project_island/section/feed/model/post_model.dart'; // Post 모델 클래스 가져오기
//MySQL/MongoDB 용 예시 코드
class PostRepository {
  static const String apiUrl = 'https://your-backend-server.com/api'; // API 기본 URL

  static Future<void> updatePost(Post postData) async {
    // 게시물을 서버에 업데이트하는 메서드
    final response = await http.post(
      Uri.parse('$apiUrl/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postData.toMap()),
      // Post 객체를 JSON으로 변환하여 요청 본문에 추가
    );

    if (response.statusCode != 200) {
      // 요청이 실패한 경우
      throw Exception('Failed to update post');
      // 예외 발생
    }
  }

  static Future<List<Post>> loadFeedList() async {
    // 피드 목록을 서버에서 가져오는 메서드
    final response = await http.get(Uri.parse('$apiUrl/posts?limit=10'));
    // API 호출을 통해 최근 게시물 10개 가져오기
    if (response.statusCode == 200) {
      // 요청이 성공한 경우
      final List<dynamic> data = jsonDecode(response.body);
      // JSON 데이터를 디코딩
      return data.map<Post>((e) => Post.fromJson(e['id'], e)).toList();
      // 데이터를 Post 객체로 변환하여 반환
    } else {
      // 요청이 실패한 경우
      throw Exception('Failed to load feed list');
      // 예외 발생
    }
  }
}

/*
임시 저장소 구현 예시 코드
import 'dart:convert'; // JSON 변환을 위한 패키지
import 'package:http/http.dart' as http; // HTTP 통신을 위한 패키지
import 'package:project_island/section/feed/model/post.dart'; // Post 모델 클래스 가져오기

class PostRepository {
  static const String apiUrl = 'https://your-backend-server.com/api'; // API 기본 URL

  static Future<void> updatePost(Post postData) async {
    // 게시물을 서버에 업데이트하는 메서드
    final response = await http.post(
      Uri.parse('$apiUrl/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postData.toMap()),
      // Post 객체를 JSON으로 변환하여 요청 본문에 추가
    );

    if (response.statusCode != 200) {
      // 요청이 실패한 경우
      throw Exception('Failed to update post');
      // 예외 발생
    }
  }

  static Future<List<Post>> loadFeedList() async {
    // 피드 목록을 서버에서 가져오는 메서드
    final response = await http.get(Uri.parse('$apiUrl/posts?limit=10'));
    // API 호출을 통해 최근 게시물 10개 가져오기
    if (response.statusCode == 200) {
      // 요청이 성공한 경우
      final List<dynamic> data = jsonDecode(response.body);
      // JSON 데이터를 디코딩
      return data.map<Post>((e) => Post.fromJson(e['id'], e)).toList();
      // 데이터를 Post 객체로 변환하여 반환
    } else {
      // 요청이 실패한 경우
      throw Exception('Failed to load feed list');
      // 예외 발생
    }
  }
}
*/