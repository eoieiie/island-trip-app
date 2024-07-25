import 'package:get/get.dart';
import '../model/my_travel_model.dart';
import '../repository/my_travel_repository.dart';

class MyTravelViewModel extends GetxController {
  var travels = <TravelModel>[].obs;
  var isLoading = true.obs;

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

  Future<void> updateTravel(int index, TravelModel updatedTravel) async {
    travels[index] = updatedTravel;
    await MyTravelRepository.saveTravelData(travels); // 저장 로직을 비동기로 호출
  }
}
