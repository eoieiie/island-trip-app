class TourApiPhotoModel {
  final String galTitle; // 사진의 제목
  final String galWebImageUrl; // 사진의 웹 이미지 URL
  final String? galPhotographyLocation; // 사진 촬영 위치 (null 가능)

  TourApiPhotoModel({
    required this.galTitle, // galTitle 초기화
    required this.galWebImageUrl, // galWebImageUrl 초기화
    this.galPhotographyLocation, // galPhotographyLocation 초기화 (선택적)
  });

  // JSON 데이터를 받아서 TourApiPhotoModel 인스턴스로 변환
  factory TourApiPhotoModel.fromJson(Map<String, dynamic> json) {
    return TourApiPhotoModel(
      galTitle: json['galTitle'], // JSON에서 'galTitle' 가져와 초기화
      galWebImageUrl: json['galWebImageUrl'], // JSON에서 'galWebImageUrl' 가져와 초기화
      galPhotographyLocation: json['galPhotographyLocation'], // JSON에서 'galPhotographyLocation' 가져와 초기화
    );
  }
}
