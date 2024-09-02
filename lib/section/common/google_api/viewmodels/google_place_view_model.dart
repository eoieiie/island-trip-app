import '../models/google_place_model.dart'; // GooglePlaceModel 클래스 임포트
import '../services/google_places_api.dart'; // GooglePlacesAPI 서비스 임포트

class GooglePlaceViewModel {
  final GooglePlacesAPI _googlePlacesAPI = GooglePlacesAPI(); // GooglePlacesAPI 인스턴스 생성

  // 장소 검색 메서드
  Future<List<GooglePlaceModel>> searchPlaces(String query) async {
    try {
      final results = await _googlePlacesAPI.searchPlaces(query); // API 호출 결과를 받아옴

      // API 결과를 로그로 출력하여 확인
      print("API searchPlaces results: $results");

      // JSON 데이터를 GooglePlaceModel로 변환
      final places = results.map<GooglePlaceModel>((json) {
        try {
          return GooglePlaceModel.fromJson(json as Map<String, dynamic>); // JSON 데이터를 모델 객체로 변환
        } catch (e) {
          print("Error parsing place JSON: $e"); // JSON 파싱 중 오류 발생 시 출력
          return GooglePlaceModel( // 기본 값으로 GooglePlaceModel 인스턴스 반환
            id: 'Unknown ID',
            name: 'Unknown Name',
            address: 'Unknown Address',
            photoUrls: [],
          );
        }
      }).toList(); // 변환된 모델 객체 리스트로 반환

      // 변환된 데이터 로그 출력
      print("Parsed GooglePlaceModels: $places");

      return places; // 변환된 장소 리스트 반환
    } catch (e) {
      print("Error in searchPlaces: $e"); // 장소 검색 중 오류 발생 시 출력
      return []; // 오류 발생 시 빈 리스트 반환
    }
  }

  // 사진 URL 가져오기 메서드
  Future<String?> fetchPhotoUrl(String photoReference) async {
    try {
      final photoUrl = await _googlePlacesAPI.fetchPhotoUrl(photoReference); // API 호출 결과로 사진 URL 받아옴

      // 가져온 사진 URL 로그로 출력
      print("Fetched photoUrl: $photoUrl");

      return photoUrl; // 사진 URL 반환
    } catch (e) {
      print("Error in fetchPhotoUrl: $e"); // 사진 URL 가져오는 중 오류 발생 시 출력
      return null; // 오류 발생 시 null 반환
    }
  }
}
