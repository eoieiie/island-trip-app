import 'package:project_island/section/common/google_api/viewmodels/google_place_view_model.dart';
import 'package:project_island/section/saved/model/saved_model.dart';

class SavedRepository {
  final GooglePlaceViewModel _googlePlaceViewModel = GooglePlaceViewModel();

  // 카테고리에 따라 장소를 검색하여 저장된 항목 리스트 반환
  Future<List<SavedItem>> getSavedItemsByCategory(String category) async {
    List<SavedItem> places = [];

    if (category == '섬') {
      final places1 = await _googlePlaceViewModel.searchPlaces('island');
      places = places1.map((place) => SavedItem.fromGooglePlaceModel(place)).toList();
    } else if (category == '명소/놀거리') {
      final places1 = await _googlePlaceViewModel.searchPlaces('명소');
      final places2 = await _googlePlaceViewModel.searchPlaces('놀거리');
      places = [...places1, ...places2].map((place) => SavedItem.fromGooglePlaceModel(place)).toList();
    }
    // 카테고리별 추가 구현
    return places;
  }

  // 북마크 토글 메서드
  void toggleBookmark(SavedItem item) {
    item.isBookmarked = !item.isBookmarked;
  }
}
