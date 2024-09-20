import '../models/google_place_model.dart';
import '../services/google_places_api.dart';


class GooglePlaceViewModel {
  final GooglePlacesAPI _googlePlacesAPI = GooglePlacesAPI();

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
