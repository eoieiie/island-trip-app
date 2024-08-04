// viewmodel/island_detail_viewmodel.dart

import 'package:get/get.dart';
import '../model/home_model.dart';
import '../repository/home_repository.dart';

// 섬 상세 정보 관리를 위한 뷰모델 클래스
class IslandDetailViewModel extends GetxController {
  // 리포지토리 인스턴스를 생성하여 데이터 소스와 상호작용
  final Repository _repository = Repository();

  // 섬 상세 정보를 관리하기 위한 Rxn 변수 (_island)
  // Rxn은 null을 허용하는 Rx 타입
  var _island = Rxn<IslandDetail>();

  // _island의 값을 외부에서 접근할 수 있도록 getter 제공
  IslandDetail? get island => _island.value;

  // 선택된 카테고리를 관리하기 위한 Rx 변수
  var _selectedCategory = '전체'.obs;

  // _selectedCategory의 값을 외부에서 접근할 수 있도록 getter 제공
  String get selectedCategory => _selectedCategory.value;

  // 선택된 카테고리에 따라 필터링된 가게 리스트를 반환하는 getter
  List<Store> get filteredStores {
    // '전체'가 선택된 경우 모든 가게를 반환
    if (_selectedCategory.value == '전체') {
      return _island.value?.stores ?? [];
    } else {
      // 선택된 카테고리에 맞는 가게들을 필터링하여 반환
      return _repository.filterStoresByCategory(_island.value?.stores ?? [], _selectedCategory.value);
    }
  }

  // 선택된 카테고리에 따라 필터링된 콘텐츠 리스트를 반환하는 getter
  List<Content> get filteredContents {
    // 선택된 카테고리가 비어 있는 경우 모든 콘텐츠를 반환
    if (_selectedCategory.value.isEmpty) {
      return _island.value?.contents ?? [];
    } else {
      // 선택된 카테고리에 맞는 콘텐츠를 필터링하여 반환
      return _island.value?.contents.where((content) => content.category == _selectedCategory.value).toList() ?? [];
    }
  }

  // 저장된 가게의 이름을 관리하는 Set (Rx 상태로 관리)
  final _savedStores = <String>{}.obs;

  // 저장된 가게 목록에 접근할 수 있도록 getter 제공
  Set<String> get savedStores => _savedStores;

  // 섬의 세부 정보를 가져와 _island에 저장하는 메서드
  void fetchIslandDetails(String islandName) {
    _island.value = _repository.fetchIslandDetails(islandName);
  }

  // 선택된 카테고리를 설정하는 메서드
  void setSelectedCategory(String category) {
    _selectedCategory.value = category;
  }

  // 가게 이름을 저장 목록에 추가하는 메서드
  void addSavedStore(String storeName) {
    _savedStores.add(storeName);
  }

  // 가게 이름을 저장 목록에서 제거하는 메서드
  void removeSavedStore(String storeName) {
    _savedStores.remove(storeName);
  }
}
