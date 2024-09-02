import '../models/tour_api_photo_model.dart'; // TourApiPhotoModel 클래스를 임포트하여 사진 데이터를 처리함
import '../services/tourism_photo_api.dart'; // TourismPhotoAPI 클래스를 임포트하여 API 호출 기능을 사용함

class TourApiViewModel {
  final TourismPhotoAPI _apiService = TourismPhotoAPI(); // API 서비스 인스턴스를 생성

  // 키워드로 사진을 검색하고 결과를 반환하는 메서드
  Future<List<TourApiPhotoModel>> searchPhotos(String keyword) async {
    final response = await _apiService.fetchPhotosByKeyword(keyword); // 주어진 키워드로 API 요청
    if (response != null) {
      // 응답이 null이 아닌 경우, JSON 데이터를 TourApiPhotoModel로 변환하여 리스트로 반환
      return response.map((json) => TourApiPhotoModel.fromJson(json)).toList();
    } else {
      // 응답이 null인 경우, 오류 메시지를 출력하고 빈 리스트를 반환
      print('No photos found for the keyword.');
      return [];
    }
  }
}
