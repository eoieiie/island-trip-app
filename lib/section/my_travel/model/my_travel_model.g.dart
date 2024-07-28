// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_travel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TravelModel _$TravelModelFromJson(Map<String, dynamic> json) {
  return TravelModel(
    id: json['id'] as String, // JSON에서 'id' 필드를 읽어와서 String으로 변환하여 설정합니다.
    title: json['title'] as String, // JSON에서 'title' 필드를 읽어와서 String으로 변환하여 설정합니다.
    startDate: DateTime.parse(json['startDate'] as String), // JSON에서 'startDate' 필드를 읽어와서 DateTime으로 변환하여 설정합니다.
    endDate: DateTime.parse(json['endDate'] as String), // JSON에서 'endDate' 필드를 읽어와서 DateTime으로 변환하여 설정합니다.
    island: json['island'] as String, // JSON에서 'island' 필드를 읽어와서 String으로 변환하여 설정합니다.
    updatedAt: DateTime.parse(json['updatedAt'] as String), // JSON에서 'updatedAt' 필드를 읽어와서 DateTime으로 변환하여 설정합니다.
  );
}

Map<String, dynamic> _$TravelModelToJson(TravelModel instance) => <String, dynamic>{
  'id': instance.id, // 객체의 'id' 필드를 JSON에 String으로 저장합니다.
  'title': instance.title, // 객체의 'title' 필드를 JSON에 String으로 저장합니다.
  'startDate': instance.startDate.toIso8601String(), // 객체의 'startDate' 필드를 ISO 8601 형식의 String으로 변환하여 JSON에 저장합니다.
  'endDate': instance.endDate.toIso8601String(), // 객체의 'endDate' 필드를 ISO 8601 형식의 String으로 변환하여 JSON에 저장합니다.
  'island': instance.island, // 객체의 'island' 필드를 JSON에 String으로 저장합니다.
  'updatedAt': instance.updatedAt.toIso8601String(), // 객체의 'updatedAt' 필드를 ISO 8601 형식의 String으로 변환하여 JSON에 저장합니다.
};
