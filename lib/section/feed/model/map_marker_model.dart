// model/map_marker_model.dart
class Place {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final List<String> activities;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.activities,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      activities: List<String>.from(json['activities']),
    );
  }
}
