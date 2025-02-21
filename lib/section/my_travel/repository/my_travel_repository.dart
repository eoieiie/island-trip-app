// lib/section/my_travel/repository/my_travel_repository.dart

import 'dart:convert'; // JSON 인코딩 및 디코딩을 위한 라이브러리를 가져옵니다.
import 'dart:io'; // 파일 I/O를 위한 라이브러리를 가져옵니다.
import 'package:flutter/services.dart'; // 플러터의 rootBundle을 사용하기 위한 라이브러리를 가져옵니다.
import 'package:path_provider/path_provider.dart'; // 파일 경로를 제공하기 위한 라이브러리를 가져옵니다.
import '../model/my_travel_model.dart'; // TravelModel 클래스를 가져옵니다.
import '../model/schedule_model.dart'; // ScheduleModel 클래스를 가져옵니다.

class MyTravelRepository {
  static Future<List<TravelModel>> loadTravelData() async {
    final directory = await getApplicationDocumentsDirectory(); // 앱의 문서 디렉토리를 가져옵니다.
    final file = File('${directory.path}/travel_data.json'); // 파일 경로를 설정합니다.

    if (!file.existsSync()) {
      await _copyAssetDataToFile(file); // 파일이 없으면 에셋 데이터를 복사합니다.
    }

    final jsonData = await file.readAsString(); // 파일에서 JSON 데이터를 읽어옵니다.
    final List<dynamic> data = json.decode(jsonData); // JSON 데이터를 디코딩합니다.

    return data.map((json) => TravelModel.fromJson(json))
        .toList(); // 디코딩된 데이터를 TravelModel 리스트로 변환하여 반환합니다.
  }

  static Future<void> saveTravelData(List<TravelModel> travels) async {
    final directory = await getApplicationDocumentsDirectory(); // 앱의 문서 디렉토리를 가져옵니다.
    final file = File('${directory.path}/travel_data.json'); // 파일 경로를 설정합니다.
    final data = travels.map((travel) => travel.toJson())
        .toList(); // TravelModel 리스트를 JSON 형식으로 변환합니다.
    await file.writeAsString(json.encode(data)); // JSON 데이터를 파일에 씁니다.
  }

  static Future<void> _copyAssetDataToFile(File file) async {
    final assetData = await rootBundle.loadString(
        'assets/data/travel_data.json'); // 에셋에서 JSON 데이터를 읽어옵니다.
    await file.writeAsString(assetData); // 읽어온 데이터를 파일에 씁니다.
  }

  // 특정 여행 ID에 대한 스케줄 데이터를 불러오는 메서드 (TravelScheduleView에서 사용)
  static Future<List<ScheduleModel>> loadSchedulesForTravel(
      String travelId) async {
    final directory = await getApplicationDocumentsDirectory(); // 앱의 문서 디렉토리를 가져옵니다.
    final file = File('${directory
        .path}/schedules_$travelId.json'); // 스케줄 데이터를 저장할 파일 경로를 설정합니다.

    if (!file.existsSync()) {
      return []; // 파일이 없으면 빈 리스트를 반환합니다.
    }

    final jsonData = await file.readAsString(); // 파일에서 JSON 데이터를 읽어옵니다.
    final List<dynamic> data = json.decode(jsonData); // JSON 데이터를 디코딩합니다.

    return data.map((json) => ScheduleModel.fromJson(json))
        .toList(); // 디코딩된 데이터를 ScheduleModel 리스트로 변환하여 반환합니다.
  }

  // 특정 여행 ID에 대한 스케줄 데이터를 저장하는 메서드 (필요할 경우 사용)
  static Future<void> saveSchedulesForTravel(String travelId,
      List<ScheduleModel> schedules) async {
    try {
      final directory = await getApplicationDocumentsDirectory(); // 앱의 문서 디렉토리를 가져옵니다.
      final file = File('${directory
          .path}/schedules_$travelId.json'); // 스케줄 데이터를 저장할 파일 경로를 설정합니다.
      final data = schedules.map((schedule) => schedule.toJson())
          .toList(); // ScheduleModel 리스트를 JSON 형식으로 변환합니다.
      await file.writeAsString(json.encode(data)); // JSON 데이터를 파일에 씁니다.
      print('스케줄 데이터 저장 완료: ${file.path}');
    } catch (e) {
      print('스케줄 데이터 저장 중 오류 발생: $e');
    }
  }
}
