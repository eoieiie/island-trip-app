import 'package:get/get.dart';
import '../model/home_model.dart';
import '../repository/home_repository.dart';

// IslandDetailViewModel 클래스 정의
class IslandDetailViewModel extends GetxController {
  var islandImages = <String>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  var islandDescription = ''.obs; // 섬 설명을 저장할 RxString
  var islandAddress = ''.obs; // 섬 주소를 저장할 RxString
  var islandName1 = ''.obs; // 섬 이름을 저장할 RxString

  var islandMagazines = <Magazine>[].obs; // 섬과 관련된 매거진을 저장할 RxList

  final Repository repository;

  IslandDetailViewModel(this.repository);

  // 초기화 로직 제거

  Future<void> fetchIslandDetails(String islandName) async {
    try {
      isLoading(true);

      // 섬의 contentId를 가져오기 위한 API 호출
      final contentId = _getContentIdByIslandName(islandName);

      // contentId가 유효한지 확인합니다.
      if (contentId == 0) {
        throw Exception('Invalid content ID for island: $islandName'); // 오류 메시지 개선
      }

      // 섬의 이미지 가져오기
      List<String> images = await repository.fetchIslandImages(contentId);
      islandImages.assignAll(images);

      // 섬의 세부 정보 가져오기
      var islandDetail = await repository.fetchIslandDetails(islandName);
      islandName1.value = islandDetail.name; // 섬 이름
      islandDescription.value = islandDetail.description;
      islandAddress.value = islandDetail.magazines.isNotEmpty
          ? islandDetail.magazines.first.address ?? '주소 없음'
          : '주소 없음';

      // 섬과 관련된 매거진 가져오기
      List<Magazine> magazines = await repository.fetchMagazinesFromApi(islandName);
      islandMagazines.assignAll(magazines); // 매거진 데이터 저장

    } catch (e) {
      errorMessage('An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  // 섬 이름에 따라 contentId를 반환하는 메서드
  int _getContentIdByIslandName(String islandName) {
    // 여기에 다른 섬의 contentId를 추가할 수 있습니다.
    switch (islandName) {
      case '안면도':
        return 125850;
      case '울릉도':
        return 126101; // 예시 contentId
      case '덕적도 비조봉':
        return 2664734;
      case '거제도':
        return 126972;
      case '진도':
        return 126307;
      default:
        return 0; // 기본 contentId, 또는 예외 처리
    }
  }
}
