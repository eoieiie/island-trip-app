import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/island_model.dart';

class IslandRepository {
  Future<List<IslandModel>> loadIslands() async {
    final String response = await rootBundle.loadString('assets/data/island_data.json');
    final List<dynamic> data = jsonDecode(response);
    return data.map((json) => IslandModel.fromJson(json)).toList();
  }
}
