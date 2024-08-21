import 'package:get/get.dart'; // GetX 패키지 가져오기
import 'package:project_island/section/feed/repository/search_repository.dart'; // SearchRepository 가져오기
import 'package:project_island/section/feed/view/search_focus_view.dart';

class SearchViewController extends GetxController {
  var query = ''.obs; // 검색어, 관찰 가능한 상태로 설정
  var searchResults = <String>[].obs; // 검색 결과 리스트, 관찰 가능한 상태로 설정
  var searchHistory = <String>[].obs; // 최근 검색 기록 리스트, 관찰 가능한 상태로 설정

  @override
  void onInit() {
    super.onInit();
    loadSearchHistory(); // 컨트롤러 초기화 시 검색 기록 로드
  }

  void search(String query) async {
    this.query.value = query; // 검색어 상태 업데이트
    var results = await SearchRepository.getSearchResults(query); // 비동기 검색 실행

    // 검색 결과와 상관없이 SearchFocusView로 이동
    Get.to(() => SearchFocusView(query: query, results: results));
    addSearchHistory(query); // 검색어를 검색 기록에 추가
  }

  /*void search(String query) async {
    this.query.value = query; // 검색어 상태 업데이트
    var results = await SearchRepository.getSearchResults(query); // 비동기 검색 실행

    if (results.isEmpty) {
      Get.to(() => SearchFocusView(query: query)); // 검색 결과가 없으면 바로 SearchFocusView로 이동 //searchResults.clear(); // 검색 결과가 없으면 리스트 초기화
    } else {
      searchResults.assignAll(results); // 검색 결과 업데이트
    }
    addSearchHistory(query); // 검색어를 검색 기록에 추가
  }*/

  void addSearchHistory(String query) async {
    if (!searchHistory.contains(query)) {
      searchHistory.add(query); // 검색 기록에 추가
      SearchRepository.saveSearchHistory(searchHistory); // 검색 기록 저장//await SearchRepository.saveSearchHistory(searchHistory.toList()); // 검색 기록 저장
    }
  }

  void removeSearchResult(int index) {
    searchResults.removeAt(index); // 특정 검색 결과 제거
  }

  void removeSearchHistoryItem(int index) async {
    searchHistory.removeAt(index); // 특정 검색 기록 제거
    SearchRepository.saveSearchHistory(searchHistory); // 제거 후 검색 기록 저장 //await SearchRepository.saveSearchHistory(searchHistory.toList()); // 검색 기록 저장
  }

  void clearSearchHistory() async {
    searchHistory.clear(); // 검색 기록 초기화
    SearchRepository.clearSearchHistory(); // 저장된 검색 기록 전체 삭제 //await SearchRepository.clearSearchHistory(); // 검색 기록 저장소에서 삭제
  }

  void loadSearchHistory() async {
    var history = await SearchRepository.loadSearchHistory(); // 저장된 검색 기록 로드
    if (history.isNotEmpty) {
      searchHistory.assignAll(history); // 검색 기록 상태 업데이트
    }
  }
}
