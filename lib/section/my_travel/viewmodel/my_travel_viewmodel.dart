// lib/section/my_travel/viewmodel/my_travel_viewmodel.dart

import 'package:get/get.dart'; // 상태 관리 및 의존성 주입을 위한 GetX 라이브러리를 가져옵니다.
import '../model/my_travel_model.dart'; // TravelModel 클래스를 가져옵니다.
import '../repository/my_travel_repository.dart'; // MyTravelRepository 클래스를 가져옵니다.

class MyTravelViewModel extends GetxController {
  var travels = <TravelModel>[].obs; // 여행 목록을 Observable 리스트로 선언합니다.
  var isLoading = true.obs; // 로딩 상태를 Observable 변수로 선언합니다.


  @override
  void onInit() {
    super.onInit();
    loadTravels(); // 뷰모델 초기화 시 여행 데이터를 로드합니다.
  }

  Future<void> loadTravels() async {
    try {
      isLoading(true); // 데이터를 로드하기 전에 로딩 상태를 true로 설정합니다.
      var loadedTravels = await MyTravelRepository.loadTravelData(); // 여행 데이터를 로드합니다.
      travels.assignAll(loadedTravels); // 로드한 데이터를 travels 리스트에 할당합니다.
    } finally {
      isLoading(false); // 데이터 로드 후 로딩 상태를 false로 설정합니다.
    }
  }

  Future<void> updateTravel(int index, TravelModel updatedTravel) async {
    travels[index] = updatedTravel; // 특정 인덱스의 여행 데이터를 업데이트합니다.
    await MyTravelRepository.saveTravelData(travels); // 업데이트된 데이터를 저장합니다.
  }
}
