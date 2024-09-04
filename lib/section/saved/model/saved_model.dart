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
