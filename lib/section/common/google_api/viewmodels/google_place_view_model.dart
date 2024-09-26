import '../models/google_place_model.dart';
import '../services/google_places_api.dart';

class GooglePlaceViewModel {
  final GooglePlacesAPI _googlePlacesAPI = GooglePlacesAPI();

  Future<List<GooglePlaceModel>> getPopularPlaces(String islandName) async {
    // Google Places API를 사용하여 섬의 인기 장소를 검색하는 로직 구현
    // 예를 들어, '관광명소', '인기 장소' 등의 키워드를 활용
    final query = '$islandName 관광명소';
    return await searchPlaces(query);
  }

  Future<List<GooglePlaceModel>> searchPlaces(String query) async {
    try {
      final results = await _googlePlacesAPI.searchPlaces(query);

      final places = results.map<GooglePlaceModel>((json) {
        try {
          return GooglePlaceModel.fromJson(json as Map<String, dynamic>);
        } catch (e) {
          return GooglePlaceModel(
            id: 'Unknown ID',
            name: 'Unknown Name',
            address: 'Unknown Address',
            photoUrls: [],
          );
        }
      }).toList();

      // "Unknown Name"이나 "Unknown Address"를 갖는 항목들을 필터링
      places.removeWhere((place) => place.name == 'Unknown Name' || place.address == 'Unknown Address');

      return places;
    } catch (e) {
      return [];
    }
  }
}