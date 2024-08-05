//import 'package:project_island/section/feed/viewmodel/map_marker_viewmodel.dart';


import 'package:get/get.dart';
import 'package:project_island/section/feed/model/map_marker_model.dart';
import 'package:project_island/section/feed/repository/map_marker_repository.dart';

class MapMarkerViewmodel extends GetxController {
  final MapMarkerRepository repository; // 레포지토리 의존성 주입
  var places = <Place>[].obs; // 장소 리스트 상태 변수, Observable로 선언하여 변경 시 UI에 반영
  var isLoading = false.obs; // 로딩 상태 변수, Observable로 선언하여 변경 시 UI에 반영

  MapMarkerViewmodel({required this.repository}); // 생성자, 레포지토리 의존성 주입

  // 마커 데이터를 로드하는 메서드
  Future<void> loadMarkers() async {
    isLoading.value = true; // 로딩 상태를 true로 설정하여 로딩 시작
    try {
      final data = await repository.fetchPlaces(); // API 호출을 통해 마커 데이터 가져오기
      places.assignAll(data); // 가져온 데이터를 places 리스트에 할당
    } catch (e) {
      print(e); // 오류가 발생한 경우 출력
    } finally {
      isLoading.value = false; // 로딩 상태를 false로 설정하여 로딩 종료
    }
  }
}
