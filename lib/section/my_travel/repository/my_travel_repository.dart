// lib/section/my_travel/repository/my_travel_repository.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../model/my_travel_model.dart';

class MyTravelRepository {
  static Future<List<TravelModel>> loadTravelData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/travel_data.json');

    if (!file.existsSync()) {
      await _copyAssetDataToFile(file);
    }

    final jsonData = await file.readAsString();
    final List<dynamic> data = json.decode(jsonData);

    return data.map((json) => TravelModel.fromJson(json)).toList();
  }

  static Future<void> saveTravelData(List<TravelModel> travels) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/travel_data.json');
    final data = travels.map((travel) => travel.toJson()).toList();
    await file.writeAsString(json.encode(data));
  }

  static Future<void> _copyAssetDataToFile(File file) async {
    final assetData = await rootBundle.loadString('assets/data/travel_data.json');
    await file.writeAsString(assetData);
  }
}
