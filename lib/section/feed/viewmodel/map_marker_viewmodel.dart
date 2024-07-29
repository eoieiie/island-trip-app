// viewmodel/place_viewmodel.dart
import 'package:get/get.dart';
import 'package:project_island/section/feed/model/map_marker_model.dart';
import 'package:project_island/section/feed/repository/map_marker_repository.dart';

class MapMarkerViewmodel extends GetxController {
  final MapMarkerRepository repository;

  MapMarkerViewmodel({required this.repository});

  var places = <Place>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlaces();
  }

  Future<void> fetchPlaces() async {
    try {
      isLoading(true);
      places.value = await repository.fetchPlaces();
    } catch (e) {
      // 오류 처리
    } finally {
      isLoading(false);
    }
  }
}
