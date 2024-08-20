// lib/section/my_travel/viewmodel/my_travel_viewmodel.dart

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../model/my_travel_model.dart';
import '../repository/my_travel_repository.dart';

class MyTravelViewModel extends GetxController {
  var travels = <TravelModel>[].obs;
  var isLoading = true.obs;
  final uuid = Uuid();

  @override
  void onInit() {
    super.onInit();
    loadTravels();
  }

  Future<void> loadTravels() async {
    try {
      isLoading(true);
      var loadedTravels = await MyTravelRepository.loadTravelData();
      travels.assignAll(loadedTravels);
    } finally {
      isLoading(false);
    }
  }

  String addTravel(String island, DateTime startDate, DateTime endDate) {
    final String imageUrl = _getImageUrlForIsland(
        island); // 섬 ID에 연결된 이미지 URL 가져오기

    final newTravel = TravelModel(
      id: uuid.v4(),
      title: '$island 여행',
      startDate: startDate,
      endDate: endDate,
      island: island,
      imageUrl: imageUrl, // 이미지 URL 추가
    );
    travels.add(newTravel);
    MyTravelRepository.saveTravelData(travels);
    return newTravel.id;
  }

// 섬 ID에 연결된 이미지 URL을 가져오는 메서드 (예시)
  String _getImageUrlForIsland(String island) {
    // 실제 URL 로직에 따라 수정 필요
    switch (island) {
      case '우도':
        return 'https://example.com/images/u-do.jpg';
      case '거제도':
        return 'https://example.com/images/geoje-do.jpg';
      case '외도':
        return 'https://example.com/images/oedo.jpg';
      default:
        return ''; // 이미지가 없는 경우 빈 문자열 반환
    }
  }


  Future<void> updateTravel(int index, TravelModel updatedTravel) async {
    updatedTravel.updatedAt = DateTime.now(); // 수정된 날짜를 현재 시간으로 업데이트
    travels[index] = updatedTravel;
    await MyTravelRepository.saveTravelData(travels);
  }

  Future<void> deleteTravel(String id) async {
    travels.removeWhere((travel) => travel.id == id);
    await MyTravelRepository.saveTravelData(travels);
  }

  Future<void> saveTravels() async {
    await MyTravelRepository.saveTravelData(travels); // 여행 데이터를 저장합니다.
  }
}