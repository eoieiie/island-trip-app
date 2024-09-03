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
      magazines.value = await repository.fetchMagazinesFromMultipleIslands(['거문도','신시도', '실미도', '장자도','우도(해양도립공원)','홍도','진도','무의도', '거제도']);

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
}