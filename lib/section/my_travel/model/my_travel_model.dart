import 'package:flutter/material.dart'; // Color를 위해 추가
import 'schedule_model.dart';
import 'package:json_annotation/json_annotation.dart'; // JSON 직렬화/역직렬화를 위한 라이브러리를 가져옵니다.

part 'my_travel_model.g.dart'; // 생성된 파일을 가져옵니다.

@JsonSerializable() // JSON 직렬화/역직렬화 가능하도록 설정합니다.
class TravelModel {
  final String id; // 여행 ID
  final String title; // 여행 제목
  final DateTime startDate; // 여행 시작 날짜
  final DateTime endDate; // 여행 종료 날짜
  final String island; // 여행지 섬 이름
  final String? imageUrl; // 여행지 이미지 URL
  DateTime updatedAt; // 마지막 업데이트 날짜
  List<ScheduleModel> schedules = [];

  TravelModel({
    required this.id, // 필수 파라미터로 여행 ID를 받습니다.
    required this.title, // 필수 파라미터로 여행 제목을 받습니다.
    required this.startDate, // 필수 파라미터로 시작 날짜를 받습니다.
    required this.endDate, // 필수 파라미터로 종료 날짜를 받습니다.
    required this.island, // 필수 파라미터로 섬 이름을 받습니다.
    this.imageUrl, // 필수 파라미터로 이미지 URL을 받습니다.
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now(); // 마지막 업데이트 날짜 기본값 설정

  factory TravelModel.fromJson(Map<String, dynamic> json) => _$TravelModelFromJson(json); // JSON 데이터를 객체로 변환합니다.
  Map<String, dynamic> toJson() => _$TravelModelToJson(this); // 객체를 JSON 데이터로 변환합니다.

  // 여행까지 남은 일수를 계산하는 getter
  int get daysUntilTravel {
    final today = DateTime.now(); // 현재 날짜를 가져옵니다.
    return startDate.difference(today).inDays; // 시작 날짜와 현재 날짜의 차이를 일수로 계산합니다.
  }

  // 여행 상태를 계산하는 getter
  String get travelStatus {
    final today = DateTime.now();
    if (today.isBefore(startDate)) {
      return '출발 ${startDate.difference(today).inDays}일 전';
    } else if (today.isAfter(endDate)) {
      return '다녀온 지 ${today.difference(endDate).inDays}일';
    } else {
      return '여행 중';
    }
  }

  // 여행 상태에 따른 텍스트 색상
  Color get statusColor {
    final today = DateTime.now();
    if (today.isBefore(startDate)) {
      return Colors.green; // 출발 전: 초록색
    } else if (today.isAfter(endDate)) {
      return Colors.grey; // 다녀온 후: 회색
    } else {
      return Colors.orange; // 여행 중: 주황색
    }
  }

  // 여행 상태에 따른 텍스트
  String get statusText {
    final today = DateTime.now();
    if (today.isBefore(startDate)) {
      return '출발 ${startDate.difference(today).inDays}일 전';
    } else if (today.isAfter(endDate)) {
      return '다녀온 지 ${today.difference(endDate).inDays}일';
    } else {
      return '여행 중';
    }
  }
}
