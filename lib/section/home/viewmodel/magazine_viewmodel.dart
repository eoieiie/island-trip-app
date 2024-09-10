import 'package:get/get.dart';
import '../model/home_model.dart';
import '../repository/home_repository.dart'; // Repository를 가져오기 위한 import

class MagazineViewModel extends GetxController {
  final Magazine magazine; // Magazine 객체
  var islandImages = <String>[].obs; // 섬 이미지 목록
  var isLoading = true.obs; // 로딩 상태
  var errorMessage = ''.obs; // 오류 메시지

  var jsonMagazines = <Magazine1>[].obs; // JSON에서 가져온 매거진 목록
  final Repository repository; // Repository 객체

  MagazineViewModel(this.magazine, this.repository);

  @override
  void onInit() {
    super.onInit();
    fetchIslandImages(); // 섬 이미지 가져오기
    fetchMagazinesFromJson(); // JSON에서 매거진 데이터 가져오기
  }

  // 섬의 이미지 데이터를 가져오는 메서드
  Future<void> fetchIslandImages() async {
    try {
      isLoading(true);

      // 섬의 contentId를 가져오기 위한 로직
      final contentId = _getContentIdByIslandName(magazine.title);

      // contentId가 유효한지 확인합니다.
      if (contentId == 0) {
        throw Exception('Invalid content ID for island: ${magazine.address}'); // 오류 메시지 개선
      }

      // 섬의 이미지 가져오기
      List<String> images = await repository.fetchIslandImages(contentId);
      islandImages.assignAll(images);

    } catch (e) {
      errorMessage('An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  // JSON에서 섬의 매거진 데이터를 가져오는 메서드
  Future<void> fetchMagazinesFromJson() async {
    try {
      isLoading(true);

      // JSON 파일에서 해당 섬 이름에 맞는 매거진 데이터를 가져옵니다.
      List<Magazine1> magazines = await repository.fetchMagazinesByIslandName(magazine.title);

      // 가져온 데이터를 상태 변수에 할당합니다.
      jsonMagazines.assignAll(magazines);
    } catch (e) {
      errorMessage('An error occurred while fetching magazines from JSON: $e');
    } finally {
      isLoading(false);
    }
  }

  // 섬 이름에 따라 contentId를 반환하는 메서드
  int _getContentIdByIslandName(String islandName) {
    switch (islandName) {
      case '안면도':
        return 125850;
      case '울릉도':
        return 126101;
      case '덕적도 비조봉':
        return 2664734;
      case '거제도':
        return 126972;
      case '진도':
        return 126307;
      default:
        return 0; // 기본 contentId 또는 예외 처리
    }
  }
}
