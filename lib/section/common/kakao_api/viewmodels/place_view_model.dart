// PlaceViewModel 클래스는 뷰와 서비스(API 호출)를 연결함
// 이 클래스는 Kakao API를 사용하여 장소 데이터를 검색하고,
// 그 결과를 PlaceModel의 리스트로 변환하여 UI에 전달함

import '../models/place_model.dart'; // PlaceModel을 import하여 JSON 데이터를 모델 객체로 변환
import '../services/kakao_api.dart'; // KakaoAPI 서비스를 import하여 API 호출을 수행
//
// import '../services/tourism_photo_api.dart';

class PlaceViewModel {
  final KakaoAPI _kakaoAPI = KakaoAPI(); // KakaoAPI의 인스턴스를 생성하여 API 호출에 사용

  // 사용자가 입력한 검색어를 바탕으로 장소를 검색하는 메서드
  // 여러 페이지에 걸쳐 장소 데이터를 검색하고, 결과를 합산하여 반환함.
  Future<List<PlaceModel>> searchPlaces(String query) async {
    List<PlaceModel> allPlaces = []; // 모든 검색 결과를 저장하기 위한 리스트 초기화

    // 3페이지까지 검색 결과를 가져오기 위해 루프 실행
    for (int page = 1; page <= 3; page++) {
      final placeData = await _kakaoAPI.searchPlaces(query, page: page, size: 15); // 각 페이지마다 장소 검색 수행
      allPlaces.addAll(placeData.map((json) => PlaceModel.fromJson(json)).toList()); // 검색된 JSON 데이터를 PlaceModel 객체로 변환하여 리스트에 추가
    }

    return allPlaces; // 모든 페이지의 결과를 포함한 리스트를 반환
  }
}
