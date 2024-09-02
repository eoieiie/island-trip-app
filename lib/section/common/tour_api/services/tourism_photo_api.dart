import 'dart:convert';  // JSON 데이터 인코딩 및 디코딩에 사용
import 'package:http/http.dart' as http;  // HTTP 요청을 보내기 위한 패키지
import 'package:flutter_dotenv/flutter_dotenv.dart';  // 환경 변수 로드를 위한 패키지

class TourismPhotoAPI {
  final String apiKey = dotenv.env['TOURISM_API_KEY']!;  // 환경 변수에서 API 키를 로드
  final String endPoint = 'http://apis.data.go.kr/B551011/PhotoGalleryService1/gallerySearchList1';  // API 엔드포인트 URL

  // 주어진 키워드로 사진 데이터를 검색하는 메서드
  Future<List<Map<String, dynamic>>?> fetchPhotosByKeyword(String keyword) async {
    final String requestUrl = '$endPoint?serviceKey=$apiKey&numOfRows=10&pageNo=1&MobileOS=ETC&MobileApp=TestApp&keyword=$keyword&_type=json';  // API 요청 URL 구성

    try {
      final response = await http.get(Uri.parse(requestUrl));  // API에 HTTP GET 요청 보내기

      if (response.statusCode == 200) {
        // 응답 바이트 데이터를 UTF-8로 디코딩
        final decodedResponse = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedResponse);  // JSON 데이터로 디코딩
        print('API Response: $data');  // 응답 데이터 출력

        if (data['response']['body']['items'] != null) {
          // items가 단일 객체인지 배열인지 확인하여 처리
          final items = data['response']['body']['items']['item'];
          if (items is List) {
            return List<Map<String, dynamic>>.from(items);  // 리스트인 경우 그대로 반환
          } else if (items is Map) {
            return [Map<String, dynamic>.from(items)];  // 단일 객체를 리스트로 변환하여 반환
          }
        } else {
          print('No items found in the response.');  // items가 없는 경우 메시지 출력
        }
      } else {
        print('Failed to load photos: ${response.statusCode} - ${response.body}');  // API 호출 실패 시 오류 메시지 출력
      }
    } catch (e) {
      print('Error occurred during API call: $e');  // 예외 발생 시 오류 메시지 출력
    }

    return null;  // 실패하거나 데이터가 없을 경우 null 반환
  }
}
