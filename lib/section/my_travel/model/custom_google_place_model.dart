import 'package:project_island/section/common/google_api/viewmodels/google_place_view_model.dart';
import 'package:project_island/section/common/google_api/models/google_place_model.dart';

class CustomGooglePlaceModel {

  final String name;
  final double? latitude;
  final double? longitude;

  CustomGooglePlaceModel({
    required this.name,
    this.latitude,
    this.longitude,
  });

  factory CustomGooglePlaceModel.fromGooglePlaceModel(GooglePlaceModel place) {
    return CustomGooglePlaceModel(
      name: place.name,
      latitude: place.latitude,
      longitude: place.longitude,
    );
  }
}