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
    final newTravel = TravelModel(
      id: uuid.v4(),
      title: '$island 여행',
      startDate: startDate,
      endDate: endDate,
      island: island,
    );
    travels.add(newTravel);
    MyTravelRepository.saveTravelData(travels);
    return newTravel.id; // 고유 ID 반환
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
