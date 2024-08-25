// PlaceModel 클래스는 Kakao API로부터 받은 장소 정보를 담기 위한 데이터 모델
// 장소 이름, 주소, 전화번호, 카테고리 그룹 이름, URL, 위도, 경도, 그리고 거리와 같은
// 장소 관련 데이터를 저장하고 JSON 데이터를 모델 인스턴스로 변환하거나 그 반대 작업을 함.

class PlaceModel {
  final String placeName; // 장소 이름을 저장하는 변수
  final String addressName; // 장소의 주소를 저장하는 변수
  final String phone; // 장소의 전화번호를 저장하는 변수
  final String categoryGroupName; // 장소의 카테고리 그룹 이름을 저장하는 변수
  final String placeUrl; // 장소의 URL을 저장하는 변수
  final double x; // 장소의 경도(longitude)를 저장하는 변수
  final double y; // 장소의 위도(latitude)를 저장하는 변수
  final String distance; // 현재 위치와의 거리를 저장하는 변수

  // 생성자: 각 필드를 필수(required)로 설정하고 초기화하는 생성자
  PlaceModel({
    required this.placeName,
    required this.addressName,
    required this.phone,
    required this.categoryGroupName,
    required this.placeUrl,
    required this.x,
    required this.y,
    required this.distance,
  });

  // JSON 데이터를 PlaceModel 객체로 변환하는 역할을 함. 외부 API에서 받은 JSON 데이터를 활용하여 PlaceModel 인스턴스를 생성
  // 즉, JSON 형식으로 전달된 데이터를 애플리케이션 내부에서 사용할 수 있는 Dart 객체로 변환
  //place_view_model.dart (ViewModel)에서
  //fromJson 메서드를 사용하여, Kakao API에서 받은 JSON 데이터를 PlaceModel 객체로 변환
  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      placeName: json['place_name'], // JSON에서 'place_name' 키의 값을 placeName에 할당
      addressName: json['address_name'], // JSON에서 'address_name' 키의 값을 addressName에 할당
      phone: json['phone'], // JSON에서 'phone' 키의 값을 phone에 할당
      categoryGroupName: json['category_group_name'], // JSON에서 'category_group_name' 키의 값을 categoryGroupName에 할당
      placeUrl: json['place_url'], // JSON에서 'place_url' 키의 값을 placeUrl에 할당
      x: double.parse(json['x']), // JSON에서 'x' 키의 값을 문자열로 받아와 double로 변환 후 x에 할당
      y: double.parse(json['y']), // JSON에서 'y' 키의 값을 문자열로 받아와 double로 변환 후 y에 할당
      distance: json['distance'], // JSON에서 'distance' 키의 값을 distance에 할당
    );
  }

  //PlaceModel 인스턴스를 JSON 형식으로 변환하는 메서드
  //PlaceModel 객체를 JSON 형식으로 변환하는 역할.객체를 다시 JSON 데이터로 직렬화
  //PlaceModel 객체를 서버로 전송하거나 저장할 때 객체를 JSON 형식으로 변환하여 사용
  //place_detail_page.dart (View)에서
  //toJson 메서드를 사용하여, PlaceModel 객체를 다시 JSON 형식으로 변환하여 화면에 표시하거나, 데이터를 전달할 때 사용
  Map<String, dynamic> toJson() {
    return {
      'place_name': placeName, // placeName 값을 JSON의 'place_name' 키에 매핑
      'address_name': addressName, // addressName 값을 JSON의 'address_name' 키에 매핑
      'phone': phone, // phone 값을 JSON의 'phone' 키에 매핑
      'category_group_name': categoryGroupName, // categoryGroupName 값을 JSON의 'category_group_name' 키에 매핑
      'place_url': placeUrl, // placeUrl 값을 JSON의 'place_url' 키에 매핑
      'x': x.toString(), // x 값을 문자열로 변환하여 JSON의 'x' 키에 매핑
      'y': y.toString(), // y 값을 문자열로 변환하여 JSON의 'y' 키에 매핑
      'distance': distance, // distance 값을 JSON의 'distance' 키에 매핑
    };
  }
}
