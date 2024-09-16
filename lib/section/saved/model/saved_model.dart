/*import 'package:project_island/section/common/google_api/models/google_place_model.dart';

class SavedItem {
  final String title;
  final String imageUrl;
  final String address;
  final String description;
  final String category;
  final String phone;
  final String website;
  final double? rating; // 평점 추가
  final bool? isOpenNow; // 영업 중 여부 추가
  bool isBookmarked;

  SavedItem({
    required this.title,
    required this.imageUrl,
    required this.address,
    required this.description,
    required this.category,
    required this.phone,
    required this.website,
    this.rating,
    this.isOpenNow,
    this.isBookmarked = false,
  });

  // GooglePlaceModel을 SavedItem으로 변환하는 메서드
  factory SavedItem.fromGooglePlaceModel(GooglePlaceModel place) {
    return SavedItem(
      title: place.name,
      imageUrl: place.photoUrls?.first ?? '', // 첫 번째 이미지 URL 사용, 없으면 빈 문자열
      address: place.address,
      description: place.rating != null ? '평점: ${place.rating} ${place.isOpenNow != null ? (place.isOpenNow! ? "영업 중" : "영업 종료") : ""}' : '정보 없음',
      category: '섬', // 필요에 따라 설정
      phone: place.phoneNumber ?? '전화번호 없음',
      website: place.website ?? '웹사이트 없음',
      rating: place.rating,
      isOpenNow: place.isOpenNow,
      isBookmarked: false,
    );
  }
}
*/
import 'package:project_island/section/common/google_api/models/google_place_model.dart';

class SavedItem {
  final String title;
  final String imageUrl;
  final String address;
  final String description;
  final String category;
  final String phone;
  final String website;
  final double? rating; // 평점 추가
  final bool? isOpenNow; // 영업 중 여부 추가
  bool isBookmarked;

  SavedItem({
    required this.title,
    required this.imageUrl,
    required this.address,
    required this.description,
    required this.category,
    required this.phone,
    required this.website,
    this.rating,
    this.isOpenNow,
    this.isBookmarked = false,
  });

  // JSON -> SavedItem
  factory SavedItem.fromJson(Map<String, dynamic> json) {
    return SavedItem(
      title: json['title'] ?? '정보 없음', // null-safe 처리
      imageUrl: json['imageUrl'] ?? 'assets/images/no_photo_available.webp', // null-safe 처리
      address: json['address'] ?? '주소 없음', // null-safe 처리
      description: json['description'] ?? '설명 없음', // null-safe 처리
      category: json['category'] ?? '카테고리 없음', // null-safe 처리
      phone: json['phone'] ?? '전화번호 없음', // null-safe 처리
      website: json['website'] ?? '웹사이트 없음', // null-safe 처리
      rating: json['rating'] != null ? json['rating'].toDouble() : null, // null-safe 처리
      isOpenNow: json['isOpenNow'] != null ? json['isOpenNow'] as bool : null, // null-safe 처리
      isBookmarked: json['isBookmarked'] ?? false, // null-safe 처리
    );
  }

  // SavedItem -> JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'address': address,
      'description': description,
      'category': category,
      'phone': phone,
      'website': website,
      'rating': rating, // null 허용
      'isOpenNow': isOpenNow, // null 허용
      'isBookmarked': isBookmarked,
    };
  }

  // GooglePlaceModel -> SavedItem 변환
  factory SavedItem.fromGooglePlaceModel(GooglePlaceModel place) {
    return SavedItem(
      title: place.name,
      imageUrl: place.photoUrls?.first ?? 'assets/images/no_photo_available.webp',
      address: place.address,
      description: place.rating != null ? '평점: ${place.rating} ${place.isOpenNow != null ? (place.isOpenNow! ? "영업 중" : "영업 종료") : ""}' : '정보 없음',
      category: '섬',
      phone: place.phoneNumber ?? '전화번호 없음',
      website: place.website ?? '웹사이트 없음',
      rating: place.rating,
      isOpenNow: place.isOpenNow,
      isBookmarked: false,
    );
  }
}
