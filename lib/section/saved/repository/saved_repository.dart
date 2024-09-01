import 'package:project_island/section/common/kakao_api/viewmodels/place_view_model.dart';
import 'package:project_island/section/common/kakao_api/models/place_model.dart';
import 'package:project_island/section/saved/model/saved_model.dart'; // SavedItem import

class SavedRepository {
  final PlaceViewModel _placeViewModel = PlaceViewModel();

  Future<List<SavedItem>> getSavedItemsByCategory(String category) async {
    List<PlaceModel> places = [];

    if (category == '명소/놀거리') {
      // "명소/놀거리"는 "문화시설"과 "관광명소"를 각각 검색하여 결과를 합침
      final places1 = await _placeViewModel.searchPlaces('문화시설');
      final places2 = await _placeViewModel.searchPlaces('관광명소');

      // 두 결과를 합친 후, categoryGroupName이 비어 있는 항목을 추가로 포함
      places = [
        ...places1,
        ...places2,
        ...places1.where((place) => place.categoryGroupName.isEmpty).toList()
      ];
    } else if (category == '섬') {
      places = await _placeViewModel.searchPlaces('섬');
    } else if (category == '음식') {
      places = await _placeViewModel.searchPlaces('음식점');
    } else if (category == '카페') {
      places = await _placeViewModel.searchPlaces('카페');
    } else if (category == '숙소') {
      places = await _placeViewModel.searchPlaces('숙박');
    } else {
      places = await _placeViewModel.searchPlaces(category); // 기본적으로 사용자가 입력한 카테고리를 검색어로 사용
    }

    // 필터링된 장소를 SavedItem으로 변환
    return places.map((place) => SavedItem.fromPlaceModel(place)).toList();
  }

  void toggleBookmark(SavedItem item) {
    item.isBookmarked = !item.isBookmarked; // 북마크 상태를 반전
  }
}
