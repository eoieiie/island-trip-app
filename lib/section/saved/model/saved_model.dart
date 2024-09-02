import 'package:project_island/section/common/kakao_api/models/place_model.dart';
class SavedItem {
  final String title; // 장소 이름
  final String imageUrl; // 이미지 URL
  final String address; // 주소
  final String description; // 설명 (전화번호와 웹사이트 포함)
  final String category; // 카테고리
  final String phone; // 전화번호
  final String website; // 웹사이트
  bool isBookmarked; // 북마크 여부

  SavedItem({
    required this.title,
    required this.imageUrl,
    required this.address,
    required this.description,
    required this.category,
    required this.phone,
    required this.website,
    this.isBookmarked = false,
  });

  // PlaceModel을 SavedItem으로 변환하는 메서드
  factory SavedItem.fromPlaceModel(PlaceModel place) {
    return SavedItem(
      title: place.placeName,
      imageUrl: place.placeUrl,
      address: place.addressName,
      description: '전화번호: ${place.phone.isNotEmpty ? place.phone : place.placeUrl}',
      category: place.categoryGroupName,
      phone: place.phone,
      website: place.placeUrl,
      isBookmarked: false, // 기본값으로 북마크 설정
    );
  }
}

