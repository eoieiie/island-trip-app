// repository/place_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_island/section/feed/model/map_marker_model.dart';

class MapMarkerRepository {
  final String apiUrl;

  MapMarkerRepository({required this.apiUrl});

  Future<List<Place>> fetchPlaces() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Place.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load places');
    }
  }
}
