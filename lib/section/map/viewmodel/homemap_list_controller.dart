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
    displayedItems.clear();
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

    // 선택된 메인 카테고리 가져오기
    String mainCategory = selectedCategory.value;

    if (subCategory == '전체') {
      // 전체 버튼이 눌렸을 때, 해당 카테고리의 모든 하위 카테고리 데이터를 병합
      // 하위 카테고리 검색을 병렬로 처리
      var futures = subCategories.map((category) async {
        var modifiedSubCategory = '${currentIsland.value} $category';
        var categoryResults = await repository.getItemsByCategory(modifiedSubCategory);

        // 각 아이템의 카테고리를 하위 카테고리로 지정
        for (var item in categoryResults) {
          item.category = category;  // 하위 카테고리명(낚시, 스쿠버다이빙, 양식,일식, etc.)을 카테고리로 지정
        }
        return categoryResults;
      }).toList();

      // 모든 비동기 작업이 완료될 때까지 기다리고, 결과 병합
      var resultsFromAllCategories = await Future.wait(futures);

      // 각 카테고리의 결과를 리스트에 추가
      for (var categoryResults in resultsFromAllCategories) {
        results.addAll(categoryResults);
      }
      // 병합한 데이터를 랜덤하게 섞음
      results.shuffle();
    } else if (subCategory == '양식') {
      // 병렬로 양식 하위 카테고리 처리
      List<String> westernDishes = ['스테이크', '파스타', '피자', '햄버거'];
      var futures = westernDishes.map((dish) async {
        var modifiedSubCategory = '${currentIsland.value} $dish';
        return await repository.getItemsByCategory(modifiedSubCategory);
      }).toList();

      // 결과 병합
      var westernResults = await Future.wait(futures);
      for (var dishResults in westernResults) {
        for (var item in dishResults) {
          item.category = '양식';
        }
        results.addAll(dishResults);
      }
      results.shuffle();
    } else if (subCategory == '일식') {
      List<String> japaneseDishes = ['초밥', '돈가스', '라멘', '튀김', '우동'];
      var futures = japaneseDishes.map((dish) async {
        var modifiedSubCategory = '${currentIsland.value} $dish';
        return await repository.getItemsByCategory(modifiedSubCategory);
      }).toList();

      var japaneseResults = await Future.wait(futures);
      for (var dishResults in japaneseResults) {
        for (var item in dishResults) {
          item.category = '일식';
        }
        results.addAll(dishResults);
      }
      results.shuffle();
    } else if (subCategory == '중식') {
      List<String> chineseDishes = ['짜장면', '짬뽕', '탕수육'];
      var futures = chineseDishes.map((dish) async {
        var modifiedSubCategory = '${currentIsland.value} $dish';
        return await repository.getItemsByCategory(modifiedSubCategory);
      }).toList();

      var chineseResults = await Future.wait(futures);
      for (var dishResults in chineseResults) {
        for (var item in dishResults) {
          item.category = '중식';
        }
        results.addAll(dishResults);
      }
      results.shuffle();
    } else if (subCategory == '분식') {
      List<String> bunsikDishes = ['떡볶이', '순대', '김밥', '라면'];
      var futures = bunsikDishes.map((dish) async {
        var modifiedSubCategory = '${currentIsland.value} $dish';
        return await repository.getItemsByCategory(modifiedSubCategory);
      }).toList();

      var bunsikResults = await Future.wait(futures);
      for (var dishResults in bunsikResults) {
        for (var item in dishResults) {
          item.category = '분식';
        }
        results.addAll(dishResults);
      }
      results.shuffle();
    } else if (subCategory == '한식') {
      List<String> koreanDishes = ['한식'];
      var futures = koreanDishes.map((dish) async {
        var modifiedSubCategory = '${currentIsland.value} $dish';
        return await repository.getItemsByCategory(modifiedSubCategory);
      }).toList();

      var koreanResults = await Future.wait(futures);
      for (var dishResults in koreanResults) {
        for (var item in dishResults) {
          item.category = '한식';
        }
        results.addAll(dishResults);
      }
      results.shuffle();
    } else {
      // 일반 하위 카테고리 선택 시
      String modifiedSubCategory = '${currentIsland.value} $subCategory';
      results = await repository.getItemsByCategory(modifiedSubCategory);

      // 각 결과에 카테고리 지정
      for (var item in results) {
        item.category = subCategory;  // 하위 카테고리로 지정
      }
    }

    // 음식과 카페를 각각 분류하는 필터 적용
    if (mainCategory == '음식') {
      results = _filterByGoogleType(results, ['restaurant', 'meal_delivery', 'meal_takeaway']);
    } else if (mainCategory == '카페') {
      results = _filterByGoogleType(results, ['cafe', 'bakery']);
    }

    // 중복된 이름과 섬 이름과 동일한 항목 필터링
    _filterOutDuplicatesAndIslandName(results, currentIsland.value);

    // 랜덤으로 섞은 결과를 별점 순으로 다시 정렬
    // results.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));

    displayedItems.assignAll(results); // 데이터를 불러온 후에 업데이트
    isLoading.value = false; // 로딩 끝
  }
  // 중복된 항목과 섬 이름과 동일한 항목을 필터링하는 함수
  void _filterOutDuplicatesAndIslandName(List<IslandModel> items, String islandName) {
    Set<String> seenNames = {}; // 이미 본 이름을 저장할 Set

    items.removeWhere((item) {
      // 중복된 이름 또는 섬 이름과 동일한 항목을 제거
      if (item.name == islandName || seenNames.contains(item.name)) {
        return true;
      } else {
        seenNames.add(item.name);
        return false;
      }
    });
  }

  // Google 'types' 필드에 따라 필터링하는 함수
  List<IslandModel> _filterByGoogleType(List<IslandModel> items, List<String> types) {
    return items.where((item) =>
    item.types != null && item.types!.any((type) => types.contains(type))
    ).toList();
  }

  // 선택된 상위 카테고리에 맞는 하위 카테고리 설정
  void updateSubCategories(String category) {
    if (category == '명소/놀거리') {
      subCategories.value = ['낚시', '스쿠버 다이빙', '계곡', '바다', '산/휴향림', '산책길', '역사', '수상 레저', '자전거'];
    } else if (category == '음식') {
      subCategories.value = ['한식', '양식', '일식', '중식', '분식'];
    } else if (category == '카페') {
      subCategories.value = ['커피', '베이커리', '아이스크림/빙수', '차', '과일/주스'];
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
