class IslandModel {
  final String name;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String iconUrl;
  final List<String> tags;

  IslandModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.iconUrl,
    required this.tags,
  });

  factory IslandModel.fromJson(Map<String, dynamic> json) {
    return IslandModel(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      imageUrl: json['imageUrl'],
      iconUrl: json['iconUrl'],
      tags: List<String>.from(json['tags']),
    );
  }
}
