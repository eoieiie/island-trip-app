// repository/map_marker_repository.dart
import 'dart:convert'; // JSON 디코딩을 위해 가져오기
import 'package:http/http.dart' as http; // HTTP 요청을 위해 가져오기
import 'package:project_island/section/feed/model/map_marker_model.dart'; // Place 모델 가져오기

class MapMarkerRepository {
  final String apiUrl; // API URL
  // final List<Activity> activities; // activities 필드 (사용하지 않을 경우 주석 처리)

  MapMarkerRepository({required this.apiUrl}); // 생성자 (activities 제거)

  // 장소 데이터를 가져오는 메서드
  Future<List<Place>> fetchPlaces() async { //fetchPlaces 메서드: HTTP GET 요청을 보내고, API에서 반환된 JSON 데이터를 Place 객체의 리스트로 변환하여 반환.
    // 성공적으로 데이터를 가져오면 List<Place>를 반환하고, 실패 시 예외를 발생시킴
    final response = await http.get(Uri.parse(apiUrl)); // API 호출
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body); // JSON 데이터 디코딩
      return data.map((json) => Place.fromJson(json)).toList(); // JSON 데이터를 Place 객체로 변환
    } else {
      throw Exception('Failed to load places'); // 오류 발생 시 예외 던지기
    }
  }
}
