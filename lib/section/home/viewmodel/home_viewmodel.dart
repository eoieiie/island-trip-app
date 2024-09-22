import 'package:get/get.dart';
import '../model/home_model.dart';
import '../repository/home_repository.dart';

// HomeViewModel 클래스를 정의하고 GetX의 컨트롤러를 확장
class HomeViewModel extends GetxController {
  var isLoading = true.obs; // 데이터를 로딩 중인지 여부를 나타내는 상태
  var magazines = <Magazine>[].obs; // 매거진 리스트 상태
  var contents = <Content>[].obs; // 물속체험 콘텐츠 리스트 상태
  var fishingContents = <Content>[].obs; // 낚시 콘텐츠 리스트 상태
  var viewpointContents = <Content>[].obs; // 전망대 콘텐츠 리스트 상태
  var cruisetripContents = <Content>[].obs; // 해수욕장 콘텐츠 리스트 상태
  var photozoneContents = <Content>[].obs; // 포토존 콘텐츠 리스트
  final Repository repository;

  HomeViewModel(this.repository) {
    _fetchData();
  }

  get currentCategoryIndex => 0.obs;

  get pageController => null;

  void _fetchData() async {
    isLoading.value = true;

    try {
      // 여러 섬의 매거진 데이터를 API에서 가져와 상태를 업데이트
      List<Magazine> fetchedMagazines = await repository.fetchMagazinesFromMultipleIslands([
        '안면도', '울릉도', '영흥도', '거제도', '진도'
      ]);

      // 각 매거진에 대해 썸네일 확인 및 대체 처리
      List<Magazine> updatedMagazines = [];
      for (var magazine in fetchedMagazines) {
        if (magazine.thumbnail.isEmpty) {
          String fallbackThumbnail = await repository.getFallbackThumbnail(magazine.title);
          magazine = magazine.copyWith(thumbnail: fallbackThumbnail); // 새로운 객체 생성
        }
        updatedMagazines.add(magazine); // 업데이트된 리스트에 추가
      }

      magazines.value = updatedMagazines;

      // 일반 콘텐츠와 다른 리스트들을 리포지토리에서 가져와 상태를 업데이트
      contents.value = repository.fetchContents();
      fishingContents.value = repository.fetchFishingContents();
      viewpointContents.value = repository.fetchViewpointContents();
      cruisetripContents.value = repository.fetchCruisetripContents();
      photozoneContents.value = repository.fetchPhotozoneContents();
    } catch (e) {
      print('Failed to fetch data: $e');
    } finally {
      isLoading.value = false;
    }
  }



  // 특정 섬에 대한 매거진 데이터 가져오기
  Future<List<Magazine>> fetchMagazinesForIsland(String islandName) async {
    try {
      return await repository.fetchMagazinesFromApi(islandName);
    } catch (e) {
      print('Failed to fetch magazines for $islandName: $e');
      return [];
    }
  }
}
