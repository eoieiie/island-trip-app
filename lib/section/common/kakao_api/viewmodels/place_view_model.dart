// PlaceViewModel 클래스는 뷰와 서비스(API 호출)를 연결함
// 이 클래스는 Kakao API를 사용하여 장소 데이터를 검색하고,
// 그 결과를 PlaceModel의 리스트로 변환하여 UI에 전달함

import '../models/place_model.dart'; // PlaceModel을 import하여 JSON 데이터를 모델 객체로 변환
import '../services/kakao_api.dart'; // KakaoAPI 서비스를 import하여 API 호출을 수행

class PlaceViewModel {
  final KakaoAPI _kakaoAPI = KakaoAPI(); // KakaoAPI의 인스턴스를 생성하여 API 호출에 사용

  // 사용자가 입력한 검색어를 바탕으로 장소를 검색하는 메서드
  Future<List<PlaceModel>> searchPlaces(String query) async {
    final placeData = await _kakaoAPI.searchPlaces(query); // KakaoAPI의 searchPlaces 메서드를 호출하여 장소 데이터를 검색
    return placeData.map((json) => PlaceModel.fromJson(json)).toList(); // 검색된 JSON 데이터를 PlaceModel 객체로 변환하여 리스트로 반환
  }
}
