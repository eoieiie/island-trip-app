// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_travel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TravelModel _$TravelModelFromJson(Map<String, dynamic> json) => TravelModel(
      id: json['id'] as String,
      title: json['title'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      island: json['island'] as String,
      imageUrl: json['imageUrl'] as String,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
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
