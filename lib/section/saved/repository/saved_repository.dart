import 'package:project_island/section/common/google_api/viewmodels/google_place_view_model.dart';
import 'package:project_island/section/common/google_api/models/google_place_model.dart';
import 'package:project_island/section/saved/model/saved_model.dart';

class SavedRepository {
  final GooglePlaceViewModel _googlePlaceViewModel = GooglePlaceViewModel();

  Future<List<SavedItem>> getSavedItemsByCategory(String category) async {
    List<GooglePlaceModel> places = [];

    // 카테고리별로 API 호출
    if (category == '명소/놀거리') {
      // "명소/놀거리"로 장소 검색
      final places1 = await _googlePlaceViewModel.searchPlaces('명소');
      final places2 = await _googlePlaceViewModel.searchPlaces('놀거리');
      places = [...places1, ...places2];
    } else if (category == '섬') {
      places = await _googlePlaceViewModel.searchPlaces('island'); // 섬 카테고리 검색
    } else if (category == '음식') {
      places = await _googlePlaceViewModel.searchPlaces('음식점');
    } else if (category == '카페') {
      places = await _googlePlaceViewModel.searchPlaces('카페');
    } else if (category == '숙소') {
      places = await _googlePlaceViewModel.searchPlaces('숙박');
    } else {
      places = await _googlePlaceViewModel.searchPlaces(category); // 기본 카테고리 검색
    }

    // 평점 순으로 정렬 (높은 평점이 상위에 오도록)
    //places.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));

    // 필터링된 장소를 SavedItem으로 변환
    return places.map((place) => SavedItem.fromGooglePlaceModel(place)).toList();
  }

  void toggleBookmark(SavedItem item) {
    item.isBookmarked = !item.isBookmarked; // 북마크 상태를 반전
  }
}
