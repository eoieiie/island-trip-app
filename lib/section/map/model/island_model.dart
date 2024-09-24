import 'package:project_island/section/common/google_api/models/google_place_model.dart'; // GooglePlaceModel 임포트

class IslandModel {
  final String name; // 장소 이름
  final double latitude; // 위도
  final double longitude; // 경도
  final String imageUrl; // 이미지 URL
  final String iconUrl; // 아이콘 URL
  final List<String> tags; // 태그 리스트
  final String title; // 제목
  final String address; // 주소
  final String description; // 설명
  final String category; // 카테고리
  final String phone; // 전화번호
  final String website; // 웹사이트 URL
  final double? rating; // 평점
  final bool? isOpenNow; // 현재 영업 중 여부
  final String placeId; // 장소의 고유 식별자 (Place ID)

  IslandModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.iconUrl,
    required this.tags,
    required this.title,
    required this.address,
    required this.description,
    required this.category,
    required this.phone,
    required this.website,
    required this.placeId, // 추가된 필드
    this.rating,
    this.isOpenNow,
  });

  // JSON을 IslandModel 객체로 변환하는 팩토리 생성자
  factory IslandModel.fromJson(Map<String, dynamic> json) {
    return IslandModel(
      name: json['name'] ?? '',
      latitude: json['latitude'] is double ? json['latitude'] : 0.0,
      longitude: json['longitude'] is double ? json['longitude'] : 0.0,
      imageUrl: json['imageUrl'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      title: json['title'] ?? '',
      address: json['address'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      rating: json['rating'], // 평점
      isOpenNow: json['isOpenNow'], // 영업 상태
      placeId: json['placeId'] ?? '',
    );
  }

  // GooglePlaceModel을 IslandModel로 변환하는 메서드
  factory IslandModel.fromGooglePlaceModel(GooglePlaceModel place) {
    return IslandModel(
      name: place.name,
      latitude: place.latitude ?? 0.0,
      longitude: place.longitude ?? 0.0,
      imageUrl: place.photoUrls?.isNotEmpty == true ? place.photoUrls!.first : 'assets/images/No_photo_available.webp',
      iconUrl: '',
      tags: [], // 태그는 필요에 따라 수정
      title: place.name,
      address: place.address,
      description: '전화번호: ${place.phoneNumber ?? '정보 없음'}',
      category: '', // 필요에 따라 수정
      phone: place.phoneNumber ?? '',
      website: place.website ?? '',
      rating: place.rating, // 평점
      isOpenNow: place.isOpenNow, // 영업 상태
      placeId: place.placeId ?? '', // `GooglePlaceModel`에 `placeId`가 있다고 가정
    );
  }

  // IslandModel 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'iconUrl': iconUrl,
      'tags': tags,
      'title': title,
      'address': address,
      'description': description,
      'category': category,
      'phone': phone,
      'website': website,
      'rating': rating, // 평점
      'isOpenNow': isOpenNow, // 영업 상태
      'placeId': placeId,
    };
  }
}
