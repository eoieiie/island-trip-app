// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_travel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TravelModel _$TravelModelFromJson(Map<String, dynamic> json) => TravelModel(
      id: json['id'] as String? ?? '', // null이면 빈 문자열로 처리
      title: json['title'] as String? ?? 'Untitled', // null이면 기본 제목 설정
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : DateTime.now(), // null이면 현재 날짜로 처리
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : DateTime.now(), // null이면 현재 날짜로 처리
      island: json['island'] as String? ?? 'Unknown', // null이면 기본 섬 이름 설정
      imageUrl: json['imageUrl'] as String?, // null 허용
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(), // null이면 현재 날짜로 처리
);


Map<String, dynamic> _$TravelModelToJson(TravelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'island': instance.island,
      'imageUrl': instance.imageUrl,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
