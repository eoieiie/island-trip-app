import 'package:get/get.dart';
import '../model/home_model.dart';
import '../repository/home_repository.dart'; // Repository를 가져오기 위한 import

class MagazineViewModel extends GetxController {
  final Magazine magazine;
  var islandImages = <String>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var jsonMagazines = <Magazine1>[].obs; // 수정된 Magazine1 사용
  final Repository repository;

  MagazineViewModel(this.magazine, this.repository);

  @override
  void onInit() {
    super.onInit();
    fetchIslandImages();
    fetchMagazinesFromJson();
  }

  Future<void> fetchMagazinesFromJson() async {
    try {
      isLoading(true);

      List<Magazine1> magazines = await repository.fetchMagazinesByIslandName(magazine.title);
      jsonMagazines.assignAll(magazines);

    } catch (e) {
      errorMessage('Error fetching magazines: $e');
    } finally {
      isLoading(false);
    }
  }

  // 각 섹션별로 이미지 호출하는 로직 추가
  Future<void> fetchIslandImages() async {
    try {
      isLoading(true);
      final contentId = _getContentIdByIslandName(magazine.title);

      if (contentId != 0) {
        List<String> images = await repository.fetchIslandImages(contentId);
        islandImages.assignAll(images);
      }

    } catch (e) {
      errorMessage('Error fetching images: $e');
    } finally {
      isLoading(false);
    }
  }

  int _getContentIdByIslandName(String islandName) {
    switch (islandName) {
      case '안면도':
        return 125850;
      case '울릉도':
        return 126101;
      case '영흥도':
        return 127629;
      case '거제도':
        return 126972;
      case '진도':
        return 126307;
      default:
        return 0;
    }
  }
}