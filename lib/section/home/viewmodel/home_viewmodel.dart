import 'package:get/get.dart';
import '../model/home_model.dart';
import '../repository/home_repository.dart';

// HomeViewModel 클래스를 정의하고 GetX의 컨트롤러를 확장
class HomeViewModel extends GetxController {
  // 상태 관리에 사용되는 변수들을 정의
  var isLoading = true.obs; // 데이터를 로딩 중인지 여부를 나타내는 상태
  var magazines = <Magazine>[].obs; // 매거진 리스트 상태
  var contents = <Content>[].obs; // 일반 콘텐츠 리스트 상태
  var fishingContents = <Content>[].obs; // 낚시 콘텐츠 리스트 상태
  var viewpointContents = <Content>[].obs; // 전망대 콘텐츠 리스트 상태
  var beachContents = <Content>[].obs; // 해수욕장 콘텐츠 리스트 상태

  // 데이터 리포지토리를 위한 필드 정의
  final Repository repository;

  // 생성자에서 repository를 초기화하고 데이터를 가져오는 메서드를 호출
  HomeViewModel(this.repository) {
    _fetchData();
  }

  // 데이터를 비동기적으로 가져오는 메서드 정의
  void _fetchData() async {
    // 데이터를 로드 중임을 나타냄
    isLoading.value = true;

    try {
      // 매거진 데이터를 API에서 가져와 상태를 업데이트
      magazines.value = await repository.fetchMagazinesFromApi();
      contents.value = repository.fetchContents();
      fishingContents.value = repository.fetchFishingContents();
      viewpointContents.value = repository.fetchViewpointContents();
      beachContents.value = repository.fetchBeachContents();
    } catch (e) {
      // 에러 처리
      print('Failed to fetch data: $e');
    } finally {
      // 데이터 로딩 완료 후 isLoading 상태를 false로 변경
      isLoading.value = false;
    }
  }
}
