import 'package:get/get.dart';
import 'package:project_island/section/map/model/island_model.dart';
import 'package:project_island/section/map/repository/island_repository.dart';

class HomemapListController extends GetxController {
  final IslandRepository repository = IslandRepository();
  var selectedCategory = ''.obs; // Observable로 변경
  var selectedSubCategory = ''.obs; // Observable로 변경
  var subCategories = <String>[].obs;  // 하위 카테고리 목록
  var isFullScreen = false.obs; // 화면 상태 관리
  var displayedItems = <IslandModel>[].obs; // 리스트 상태 관리
  var currentIsland = ''.obs; // 현재 선택된 섬
  var isLoading = false.obs; // 로딩 상태 추가


  // 초기 아이템 로드
  void loadInitialItems(String islandName) async {
    isLoading.value = true; // 로딩 시작
    currentIsland.value = islandName; // 섬 이름을 저장
    var results = await repository.getItemsByCategory(islandName); // 섬에 해당하는 데이터를 가져옴
    displayedItems.assignAll(results);
    isLoading.value = false; // 로딩 끝
  }

  // 검색창 제출 처리 (onSearchSubmitted)
  void onSearchSubmitted(String query) async {
    if (query.isNotEmpty) {
      String modifiedQuery = '${selectedCategory.value} $query';
      var results = await repository.getItemsByCategory(modifiedQuery);
      displayedItems.assignAll(results);
    }
  }
  // 초기화 메서드
  void resetCategories() {
    selectedCategory.value = '';  // 상위 카테고리 초기화
    selectedSubCategory.value = '';  // 하위 카테고리 초기화
    subCategories.clear();  // 하위 카테고리 목록 비우기
  }

  // 상위 카테고리 선택 처리
  Future<void> onCategorySelected(String category) async {
    isLoading.value = true; // 로딩 시작
    selectedCategory.value = category;  // 선택된 카테고리 업데이트
    updateSubCategories(category);  // 카테고리 선택 시 하위 카테고리 업데이트
    await onSubCategorySelected('전체');  // '전체' 버튼이 선택된 것처럼 동작하도록 호출
    isLoading.value = false; // 로딩 끝
  }

  // 하위 카테고리 선택 처리 (onSubCategorySelected)
  Future<void> onSubCategorySelected(String subCategory) async {
    isLoading.value = true; // 로딩 시작
    selectedSubCategory.value = subCategory; // 선택된 서브 카테고리 업데이트

    List<IslandModel> results = [];

    if (subCategory == '전체') {
      // 전체 버튼이 눌렸을 때, 해당 카테고리의 모든 하위 카테고리 데이터를 병합
      for (var category in subCategories) {
        var modifiedSubCategory = '${currentIsland.value} $category';
        var categoryResults = await repository.getItemsByCategory(modifiedSubCategory);
        results.addAll(categoryResults);
      }
      // 병합한 데이터를 랜덤하게 섞음
      results.shuffle();
    } else {
      // 일반 하위 카테고리 선택 시
      String modifiedSubCategory = '${currentIsland.value} $subCategory';
      results = await repository.getItemsByCategory(modifiedSubCategory);
    }

    displayedItems.assignAll(results); // 데이터를 불러온 후에 업데이트
    isLoading.value = false; // 로딩 끝
  }


  // 선택된 상위 카테고리에 맞는 하위 카테고리 설정
  void updateSubCategories(String category) {
    if (category == '관심') {
      subCategories.value = ['섬', '명소/놀거리', '음식', '카페', '숙소'];
    } else if (category == '명소/놀거리') {
      subCategories.value = ['낚시', '스쿠버 다이빙', '계곡', '바다', '서핑', '산책길', '역사', '수상 레저', '자전거'];
    } else if (category == '음식') {
      subCategories.value = ['한식', '양식', '일식', '중식', '분식',];
    } else if (category == '카페') {
      subCategories.value = ['커피', '베이커리', '아이스크림/빙수', '차', '과일/주스', '전통 디저트'];
    } else if (category == '숙소') {
      subCategories.value = ['모텔', '호텔/리조트', '캠핑', '게하/한옥', '펜션'];

    }
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
