// lib/section/my_travel/model/my_travel_model.dart

import 'package:json_annotation/json_annotation.dart';

part 'my_travel_model.g.dart';

@JsonSerializable()
class TravelModel {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String island;

  TravelModel({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.island,
  });

  factory TravelModel.fromJson(Map<String, dynamic> json) => _$TravelModelFromJson(json);
  Map<String, dynamic> toJson() => _$TravelModelToJson(this);

  // Add daysUntilTravel getter
  int get daysUntilTravel {
    final today = DateTime.now();
    return startDate.difference(today).inDays;
  }
}
