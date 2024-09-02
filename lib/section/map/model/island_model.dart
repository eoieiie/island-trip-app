import 'package:project_island/section/common/kakao_api/models/place_model.dart';
class IslandModel {
  final String name; // 장소 이름을 위한 필드
  final double latitude; // 위도를 위한 필드 (double 타입)
  final double longitude; // 경도를 위한 필드 (double 타입)
  final String imageUrl; // 이미지 URL 필드
  final String iconUrl; // 아이콘 URL 필드
  final List<String> tags; // 태그 리스트 필드
  final String title; // 제목 필드
  final String address; // 주소 필드
  final String description; // 설명 필드
  final String category; // 카테고리 필드
  final String phone; // 전화번호 필드
  final String website; // 웹사이트 URL 필드
  bool isBookmarked; // 북마크 여부 필드

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
    this.isBookmarked = false,
  });

  // JSON을 IslandModel 객체로 변환하는 팩토리 생성자
  factory IslandModel.fromJson(Map<String, dynamic> json) {
    return IslandModel(
      name: json['name'] ?? '', // JSON에서 name 필드 매핑, 없을 경우 빈 문자열 기본값
      latitude: json['latitude'] is double ? json['latitude'] : 0.0, // JSON에서 latitude 필드 매핑, 없을 경우 0.0 기본값
      longitude: json['longitude'] is double ? json['longitude'] : 0.0, // JSON에서 longitude 필드 매핑, 없을 경우 0.0 기본값
      imageUrl: json['imageUrl'] ?? '', // JSON에서 imageUrl 필드 매핑, 없을 경우 빈 문자열 기본값
      iconUrl: json['iconUrl'] ?? '', // JSON에서 iconUrl 필드 매핑, 없을 경우 빈 문자열 기본값
      tags: List<String>.from(json['tags'] ?? []), // JSON에서 tags 필드 매핑, 없을 경우 빈 리스트 기본값
      title: json['title'] ?? '', // JSON에서 title 필드 매핑, 없을 경우 빈 문자열 기본값
      address: json['address'] ?? '', // JSON에서 address 필드 매핑, 없을 경우 빈 문자열 기본값
      description: json['description'] ?? '', // JSON에서 description 필드 매핑, 없을 경우 빈 문자열 기본값
      category: json['category'] ?? '', // JSON에서 category 필드 매핑, 없을 경우 빈 문자열 기본값
      phone: json['phone'] ?? '', // JSON에서 phone 필드 매핑, 없을 경우 빈 문자열 기본값
      website: json['website'] ?? '', // JSON에서 website 필드 매핑, 없을 경우 빈 문자열 기본값
      isBookmarked: json['isBookmarked'] ?? false, // JSON에서 isBookmarked 필드 매핑, 없을 경우 false 기본값
    );
  }

  // PlaceModel을 IslandModel로 변환하는 메서드
  factory IslandModel.fromPlaceModel(PlaceModel place) {
    return IslandModel(
      name: place.placeName, // 장소 이름을 name으로 설정
      latitude: place.y, // 위도 설정 (double 타입)
      longitude: place.x, // 경도 설정 (double 타입)
      imageUrl: place.placeUrl, // 장소 URL을 이미지 URL로 설정
      iconUrl: '', // 아이콘 URL은 없으므로 빈 값으로 설정하거나 필요에 맞게 조정
      tags: [], // 태그는 없으므로 빈 리스트로 설정하거나 필요에 맞게 조정
      title: place.placeName, // 장소 이름을 IslandModel의 제목으로 설정
      address: place.addressName, // 장소의 주소를 설정
      description: '전화번호: ${place.phone.isNotEmpty ? place.phone : place.placeUrl}',
      // 설명 필드는 전화번호가 있는 경우 전화번호를, 그렇지 않으면 장소 URL을 넣음
      category: place.categoryGroupName, // 장소의 카테고리 그룹 이름을 설정
      phone: place.phone, // 장소의 전화번호를 설정
      website: place.placeUrl, // 웹사이트 URL을 설정
      isBookmarked: false, // 북마크 상태는 기본값으로 false
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
      'isBookmarked': isBookmarked,
    };
  }
}
