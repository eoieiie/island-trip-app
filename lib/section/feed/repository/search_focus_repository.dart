import 'package:get_storage/get_storage.dart';

class SearchFocusRepository {
  static final _box = GetStorage(); // GetStorage 사용

  static List<String> getSearchResults(String query) {
    // 실제 데이터베이스나 API에서 검색을 수행하도록 이 부분을 구현해야 함
    // 예시로 더미 데이터를 반환합니다.
    List<String> dummyData = ['울릉도 맛집', '울릉도', '제주도 맛집'];
    return dummyData.where((item) => item.contains(query)).toList();
  }
  static List<String> search(String query) {
    // 실제 데이터베이스나 API에서 검색을 수행하도록 이 부분을 구현해야 함
    return []; // 예시로 빈 리스트 반환
  }

  static void saveSearchHistory(List<String> history) {
    _box.write('search_history', history);
  }

  static List<String> loadSearchHistory() {
    return _box.read<List<String>>('search_history') ?? [];
  }

  static void clearSearchHistory() {
    _box.remove('search_history');
  }
}
