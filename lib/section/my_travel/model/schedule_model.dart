// lib/section/my_travel/model/schedule_model.dart

class ScheduleModel {
  final String id;
  final String title;
  final DateTime date;
  final DateTime startTime; // 시작 시간
  final DateTime endTime;   // 종료 시간
  final String? memo;

  ScheduleModel({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime, // 생성자에 추가
    required this.endTime,   // 생성자에 추가
    this.memo,
  });
  // JSON 데이터를 ScheduleModel 객체로 변환하는 메서드
  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      memo: json['memo'] ?? '',
    );
  }

  // ScheduleModel 객체를 JSON 형식으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'memo': memo,
    };
  }
}
