import 'dart:convert';  // JSON 데이터 파싱
import 'package:http/http.dart' as http;  // HTTP 요청
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GooglePlacesAPI {
  final String apiKey = dotenv.env['GOOGLE_API_KEY']!;  // .env 파일에서 API 키 로드

  // 장소 검색 메서드
  Future<List<dynamic>> searchPlaces(String query) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey'; // API 요청 URL 생성

    try {
      final response = await http.get(Uri.parse(url)); // HTTP GET 요청

      if (response.statusCode == 200) { // HTTP 응답이 200(성공)일 경우
        final data = json.decode(response.body); // 응답 본문 JSON 파싱
        if (data['status'] == 'OK') { // API 응답 상태 확인
          return data['results']; // 검색 결과 반환
        } else {
          print('API Error: ${data['status']} - ${data['error_message']}'); // API 에러 출력
          throw Exception('Failed to load places'); // 예외 발생
        }
      } else {
        print('HTTP Error: ${response.statusCode}'); // HTTP 에러 출력
        throw Exception('Failed to load places'); // 예외 발생
      }
    } catch (e) {
      print('Exception during API call: $e'); // 예외 출력
      throw Exception('Failed to load places'); // 예외 발생
    }
  }

  // 사진 URL 가져오기 메서드
  Future<String?> fetchPhotoUrl(String photoReference) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey'; // 사진 API URL 생성

    try {
      final response = await http.get(Uri.parse(url)); // HTTP GET 요청

      if (response.statusCode == 200) { // HTTP 응답이 200(성공)일 경우
        return response.headers['location']; // 응답 헤더에서 사진 URL 반환
      } else {
        print('HTTP Error: ${response.statusCode}'); // HTTP 에러 출력
        return null; // 실패 시 null 반환
      }
    } catch (e) {
      print('Exception during photo API call: $e'); // 예외 출력
      return null; // 실패 시 null 반환
    }
  }
}
