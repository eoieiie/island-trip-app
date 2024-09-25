import 'package:get/get.dart';
import 'package:project_island/section/map/model/island_model.dart';
import 'package:project_island/section/map/repository/island_repository.dart';
//
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
    } else if (subCategory == '양식') {
      List<String> westernDishes = ['스테이크', '파스타', '피자', '햄버거', '바베큐'];
      for (var dish in westernDishes) {
        var modifiedSubCategory = '${currentIsland.value} $dish';
        var dishResults = await repository.getItemsByCategory(modifiedSubCategory);
        results.addAll(dishResults);
      }
      results.shuffle();
    } else if (subCategory == '일식') {
      List<String> japaneseDishes = ['초밥', '돈가스', '라멘', '튀김', '우동'];
      for (var dish in japaneseDishes) {
        var modifiedSubCategory = '${currentIsland.value} $dish';
        var dishResults = await repository.getItemsByCategory(modifiedSubCategory);
        results.addAll(dishResults);
      }
      results.shuffle();
    } else if (subCategory == '중식') {
      List<String> chineseDishes = ['짜장면', '짬뽕', '탕수육'];
      for (var dish in chineseDishes) {
        var modifiedSubCategory = '${currentIsland.value} $dish';
        var dishResults = await repository.getItemsByCategory(modifiedSubCategory);
        results.addAll(dishResults);
      }
      results.shuffle();
    } else if (subCategory == '분식') {
      List<String> bunsikDishes = ['떡볶이', '순대', '김밥', '라면'];
      for (var dish in bunsikDishes) {
        var modifiedSubCategory = '${currentIsland.value} $dish';
        var dishResults = await repository.getItemsByCategory(modifiedSubCategory);
        results.addAll(dishResults);
      }
      results.shuffle();
    } else if (subCategory == '한식') {
      List<String> koreanDishes = ['한식'];
      for (var dish in koreanDishes) {
        var modifiedSubCategory = '${currentIsland.value} $dish';
        var dishResults = await repository.getItemsByCategory(modifiedSubCategory);
        results.addAll(dishResults);
      }
      results.shuffle();
    } else {
      // 일반 하위 카테고리 선택 시
      String modifiedSubCategory = '${currentIsland.value} $subCategory';
      results = await repository.getItemsByCategory(modifiedSubCategory);
    }


    // 랜덤으로 섞은 결과를 별점 순으로 다시 정렬
    results.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));

    displayedItems.assignAll(results); // 데이터를 불러온 후에 업데이트
    isLoading.value = false; // 로딩 끝
  }


  // 선택된 상위 카테고리에 맞는 하위 카테고리 설정
  void updateSubCategories(String category) {
    if (category == '명소/놀거리') {
      subCategories.value = ['낚시', '스쿠버 다이빙', '계곡', '전망대', '바다', '서핑', '산책길', '역사', '수상 레저',];
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
      isFullScreen.value = true; // 전체 화면 상태로 변경
    } else if (extent < 1.0 && isFullScreen.value) {
      isFullScreen.value = false; // 전체 화면 해제
    }
  }

  // '지도 보기' 버튼 눌렀을 때
  void onMapButtonPressed() {
    isFullScreen.value = false;
  }
}
