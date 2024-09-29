//google_places_api.dart파일
import 'dart:convert';  // JSON 데이터 파싱
import 'package:http/http.dart' as http;  // HTTP 요청
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GooglePlacesAPI {
  final String apiKey = dotenv.env['GOOGLE_API_KEY']!;  // .env 파일에서 API 키 로드

  Future<List<dynamic>> searchPlaces(String query, {int maxResults = 40}) async { //20개씩 3개 60이 최대
    List<dynamic> allResults = [];  // 모든 결과를 저장할 리스트
    String? nextPageToken;  // 다음 페이지 토큰

    do {
      // 페이지 토큰이 있으면 URL에 포함
      final url =
          'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&language=ko&key=$apiKey${nextPageToken != null ? '&pagetoken=$nextPageToken' : ''}';

      try {
        final response = await http.get(Uri.parse(url)); // HTTP GET 요청

        if (response.statusCode == 200) { // HTTP 응답이 200(성공)일 경우
          final data = json.decode(response.body); // 응답 본문 JSON 파싱

          if (data['status'] == 'OK') { // API 응답 상태 확인
            allResults.addAll(data['results']); // 현재 페이지의 결과를 리스트에 추가
            nextPageToken = data['next_page_token']; // 다음 페이지 토큰 저장

            // 원하는 최대 개수에 도달하면 반복을 중단
            if (allResults.length >= maxResults) {
              return allResults.take(maxResults).toList();  // 원하는 개수만큼만 반환
            }

            // API의 next_page_token은 2초 지연 후에 사용 가능하므로, 지연을 추가
            if (nextPageToken != null) {
              await Future.delayed(const Duration(seconds: 2));
            }
          } else {
            throw Exception('Failed to load places');
          }
        } else {
          throw Exception('Failed to load places');
        }
      } catch (e) {
        throw Exception('Failed to load places');
      }
    } while (nextPageToken != null && allResults.length < maxResults);  // 다음 페이지가 있고, 결과가 원하는 개수보다 적을 때만 반복

    return allResults.take(maxResults).toList(); // 최종적으로 원하는 개수만 반환
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
        return null; // 실패 시 null 반환
      }
    } catch (e) {
      return null; // 실패 시 null 반환
    }
  }
}
