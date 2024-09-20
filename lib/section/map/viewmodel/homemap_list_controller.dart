import 'package:get/get.dart';
import 'package:project_island/section/map/model/island_model.dart';
import 'package:project_island/section/map/repository/island_repository.dart';

class HomemapListController extends GetxController {
  final IslandRepository repository = IslandRepository();
  var selectedCategory = ''.obs; // Observable로 변경
  var selectedSubCategory = ''.obs; // Observable로 변경
  var isFullScreen = false.obs; // 화면 상태 관리
  var displayedItems = <IslandModel>[].obs; // 리스트 상태 관리
  var currentIsland = ''.obs; // 현재 선택된 섬

  // 초기 아이템 로드
  void loadInitialItems(String islandName) async {
    currentIsland.value = islandName; // 섬 이름을 저장
    var results = await repository.getItemsByCategory(islandName); // 섬에 해당하는 데이터를 가져옴
    displayedItems.assignAll(results);
  }

  // 검색창 제출 처리 (onSearchSubmitted)
  void onSearchSubmitted(String query) async {
    if (query.isNotEmpty) {
      String modifiedQuery = '${selectedCategory.value} $query';
      var results = await repository.getItemsByCategory(modifiedQuery);
      displayedItems.assignAll(results);
    }
  }

  // 카테고리 선택 처리
  void onCategorySelected(String category) async {
    String modifiedCategory = '${currentIsland.value} $category'; // 섬에 따른 카테고리 필터링
    var results = await repository.getItemsByCategory(modifiedCategory);
    selectedCategory.value = category;
    displayedItems.assignAll(results);
  }

  // 서브 카테고리 선택 처리 (onSubCategorySelected)
  void onSubCategorySelected(String subCategory) async {
    String modifiedSubCategory = '${currentIsland.value} $subCategory'; // 섬에 따른 서브 카테고리 필터링
    var results = await repository.getItemsByCategory(modifiedSubCategory);
    selectedSubCategory.value = subCategory;
    displayedItems.assignAll(results);
  }

  // 스크롤 이벤트 처리
  void handleScroll(double extent) {
    if (extent == 1.0 && !isFullScreen.value) {
      isFullScreen.value = true;
    } else if (extent < 1.0 && isFullScreen.value) {
      isFullScreen.value = false;
    }
  }

  // '지도 보기' 버튼 눌렀을 때
  void onMapButtonPressed() {
    isFullScreen.value = false;
  }

  // 북마크 토글 기능
  void toggleBookmark(IslandModel item) {
    repository.toggleBookmark(item); // 북마크 상태를 저장소에서 변경
    displayedItems.refresh(); // 리스트 상태를 갱신하여 UI 업데이트
  }

  // 저장된 항목들을 가져오는 메서드
  Future<List<IslandModel>> getSavedItems() async {
    return await repository.getSavedItems(); // 저장된 항목을 가져옴
  }
}
