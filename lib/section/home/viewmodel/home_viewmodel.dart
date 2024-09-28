import 'package:get/get.dart';
import '../model/home_model.dart';
import '../repository/home_repository.dart';

// HomeViewModel: Home 화면에서 사용하는 데이터를 관리하는 ViewModel
// GetX의 상태 관리 기능을 사용하여 데이터 상태를 반영
class HomeViewModel extends GetxController {
  var isLoading = true.obs; // 데이터를 로딩 중인지 여부를 나타내는 상태
  var magazines = <Magazine>[].obs; // 매거진 리스트 상태
  final Repository repository; // 데이터 저장소 (API 호출 및 로컬 데이터 로드)

  // 생성자에서 저장소를 받아 데이터 초기화
  HomeViewModel(this.repository) {
    fetchData(); // 데이터를 가져오는 함수 호출
  }

  // 현재 선택된 카테고리 인덱스 상태
  get currentCategoryIndex => 0.obs;

  // 페이지 컨트롤러 (사용하지 않는 부분이므로 null로 설정)
  get pageController => null;

  // 데이터를 가져오는 비동기 함수
  Future<void> fetchData() async {
    isLoading.value = true; // 로딩 상태 시작

    try {
      // 여러 섬의 매거진 데이터를 API에서 가져옴
      List<Magazine> fetchedMagazines = await repository.fetchMagazinesFromMultipleIslands([
        '안면도', '울릉도', '영흥도', '거제도', '진도'
      ]);

      // 각 매거진에 대해 썸네일이 없을 경우 대체 썸네일을 가져옴
      List<Magazine> updatedMagazines = [];
      for (var magazine in fetchedMagazines) {
        if (magazine.thumbnail.isEmpty) {
          String fallbackThumbnail = await repository.getFallbackThumbnail(magazine.title);
          magazine = magazine.copyWith(thumbnail: fallbackThumbnail);
        }
        updatedMagazines.add(magazine); // 업데이트된 매거진 리스트에 추가
      }

      // 매거진 리스트 상태 업데이트
      magazines.value = updatedMagazines;

    } catch (e) {
      print('Failed to fetch data: $e');
    } finally {
      isLoading.value = false; // 로딩 상태 종료
    }
  }

  // 특정 섬에 대한 매거진 데이터를 가져오는 함수
  Future<List<Magazine>> fetchMagazinesForIsland(String islandName) async {
    try {
      return await repository.fetchMagazinesFromApi(islandName);
    } catch (e) {
      print('Failed to fetch magazines for $islandName: $e');
      return [];
    }
  }
}
