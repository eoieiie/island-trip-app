import 'package:flutter_dotenv/flutter_dotenv.dart';


//일단 사용 가능한 정보 죄다 끌어옴

class GooglePlaceModel {
  final String id;  // 장소의 고유 ID
  final String name;  // 장소 이름
  final String address;  // 주소
  final List<String>? photoUrls;  // 장소의 사진 URL 리스트, 없을 수도 있음
  final double? rating;  // 장소의 평점
  final bool? isOpenNow;  // 현재 영업 중인지
  final String? phoneNumber;  // 전화번호
  final String? website;  // 웹사이트 URL
  final double? latitude;  // 위도
  final double? longitude; // 경도

  // 생성자 - GooglePlaceModel 인스턴스를 생성하는 함수
  GooglePlaceModel({
    required this.id, //필수
    required this.name,
    required this.address,
    this.photoUrls,  //필수아님
    this.rating,
    this.isOpenNow,
    this.phoneNumber,
    this.website,
    this.latitude,
    this.longitude,
  });

  // fromJson 팩토리 생성자 - JSON 데이터를 받아 GooglePlaceModel 인스턴스를 생성
  factory GooglePlaceModel.fromJson(Map<String, dynamic> json) {
    try {
      // .env 파일에서 API 키를 불러옴
      final apiKey = dotenv.env['GOOGLE_API_KEY'];

      // GooglePlaceModel 인스턴스 생성, JSON 데이터를 각 필드에 매핑함
      return GooglePlaceModel(
        id: json['place_id'] ?? 'Unknown ID',  // place_id를 가져오고 없으면 'Unknown ID'로 설정
        name: json['name'] ?? 'Unknown Name',  // name을 가져오고 없으면 'Unknown Name'으로 설정
        address: json['formatted_address'] ?? 'Unknown Address',  // formatted_address를 가져오고 없으면 'Unknown Address'로 설정
        // 사진 정보가 있으면 URL 리스트를 생성, 없으면 null로 설정
        photoUrls: json['photos'] != null
            ? (json['photos'] as List)
            .map((photo) =>
        'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photo['photo_reference']}&key=$apiKey')
            .toList() //사진의 해상도를 400으로 설정. 모바일 환경에서 너무 큰 이미지는 로딩 시간이 길어질 수 있고, 너무 작은 이미지는 품질이 떨어질 수 있어 400px 정도가 적당하다고 함.

            : null,
        // rating 값이 있으면 double로 변환하고 없으면 null로 설정
        rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
        // open_now 값이 있으면 bool
        isOpenNow: json['opening_hours'] != null ? json['opening_hours']['open_now'] as bool : null,
        // phoneNumber와 website는 값이 있으면 그대로 가져옴
        phoneNumber: json['formatted_phone_number'],
        website: json['website'],
        // geometry와 location이 있으면 위도(lat)를 가져오고 없으면 null
        latitude: json['geometry'] != null && json['geometry']['location'] != null
            ? json['geometry']['location']['lat'] as double : null,
        // 경도(lng)를 가져오고 없으면 null
        longitude: json['geometry'] != null && json['geometry']['location'] != null
            ? json['geometry']['location']['lng'] as double : null,
      );
    } catch (e) {
      // JSON 파싱 중 에러가 발생하면 기본 값으로 아래 GooglePlaceModel 인스턴스를 반환
      print('Error parsing JSON: $e');
      return GooglePlaceModel(
        id: 'Unknown ID',  // 에러 발생 시 기본 값으로 설정
        name: 'Unknown Name',  // 에러 발생 시 기본 값으로 설정
        address: 'Unknown Address',  // 에러 발생 시 기본 값으로 설정
        photoUrls: [],  // 에러 발생 시 빈 리스트로 설정
        rating: null,  // 에러 발생 시 null로 설정
        isOpenNow: null,  // 에러 발생 시 null로 설정
        phoneNumber: null,  // 에러 발생 시 null로 설정
        website: null,  // 에러 발생 시 null로 설정
        latitude: null,  // 에러 발생 시 null로 설정
        longitude: null,  // 에러 발생 시 null로 설정
      );
    }
  }
}
