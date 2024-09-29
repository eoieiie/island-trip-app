// lib/section/my_travel/model/schedule_model.dart

class ScheduleModel {
  final String id; // 일정 ID
  final String title; // 일정 제목
  final DateTime date; // 일정 날짜
  final DateTime startTime; // 일정 시작 시간
  final DateTime endTime; // 일정 종료 시간
  final String? memo; // 일정 메모 (선택적)
  final double? latitude; // 장소의 위도 (선택적)
  final double? longitude; // 장소의 경도 (선택적)
  final List<String>? imageUrls; // 이미지 URL 목록, 로컬 asset 이미지도 포함 가능 (선택적)

  // 생성자: 필수 필드와 선택적 필드들을 초기화
  ScheduleModel({
    required this.id, // 일정 ID 필수
    required this.title, // 일정 제목 필수
    required this.date, // 일정 날짜 필수
    required this.startTime, // 일정 시작 시간 필수
    required this.endTime, // 일정 종료 시간 필수
    this.memo, // 메모는 선택적
    this.latitude, // 위도는 선택적
    this.longitude, // 경도는 선택적
    this.imageUrls, // 이미지 URL 목록은 선택적
  });

  // JSON 데이터를 ScheduleModel 객체로 변환하는 팩토리 메서드
  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'], // JSON에서 id 읽어오기
      title: json['title'], // JSON에서 title 읽어오기
      date: DateTime.parse(json['date']), // 날짜는 문자열에서 DateTime으로 변환
      startTime: DateTime.parse(json['startTime']), // 시작 시간 문자열을 DateTime으로 변환
      endTime: DateTime.parse(json['endTime']), // 종료 시간 문자열을 DateTime으로 변환
      memo: json['memo'] ?? '', // 메모가 없으면 빈 문자열 할당
      latitude: json['latitude'] != null ? json['latitude'].toDouble() : null, // 위도 값이 있으면 변환
      longitude: json['longitude'] != null ? json['longitude'].toDouble() : null, // 경도 값이 있으면 변환
      imageUrls: json['imageUrls'] != null ? List<String>.from(json['imageUrls']) : null, // 이미지 URL 목록 처리
    );
  }

  // ScheduleModel 객체를 JSON 형식으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id, // id 필드 변환
      'title': title, // title 필드 변환
      'date': date.toIso8601String(), // date를 ISO 8601 형식 문자열로 변환
      'startTime': startTime.toIso8601String(), // startTime을 ISO 8601 형식 문자열로 변환
      'endTime': endTime.toIso8601String(), // endTime을 ISO 8601 형식 문자열로 변환
      'memo': memo, // memo 필드 변환
      'latitude': latitude, // latitude 필드 변환
      'longitude': longitude, // longitude 필드 변환
      'imageUrls': imageUrls, // imageUrls 필드 변환 (여러 개 가능)
    };
  }
}
