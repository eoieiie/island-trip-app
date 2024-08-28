class SavedItem {
  final String title; // 제목
  final String imageUrl; // 이미지 URL
  final String address; // 주소
  final String description; // 설명
  final double rating; // 평점
  final String category; // 카테고리
  bool isBookmarked; // 북마크 여부

  SavedItem({
    required this.title,
    required this.imageUrl,
    required this.address,
    required this.description,
    required this.rating,
    required this.category, // 카테고리 필수
    this.isBookmarked = false,
  });
}
