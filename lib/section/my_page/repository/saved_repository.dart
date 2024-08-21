import 'package:project_island/section/my_page/model/saved_model.dart';

class SavedRepository {
  // 저장소 클래스
  final List<SavedItem> _savedItems = [
    // 샘플 데이터 리스트
    SavedItem(
      title: "안면도 자연 휴양림",
      imageUrl: "https://lh5.googleusercontent.com/p/AF1QipPjOOUWd1JMnbeD3ZBmlHIdL3e_pUSo-ydQEWGR=w675-h390-n-k-no",
      address: "인천 서해 도동1길 5-3",
      description: "숲길과 바닷길이 아름다운 산책코스",
      rating: 4.9,
      category: "명소/놀거리", // 카테고리 지정
    ),
    SavedItem(
      title: "꽃게다리",
      imageUrl: "http://bbkk.kr/d/t/18/1862_%EB%A9%94%EC%9D%B8%EC%82%AC%EC%A7%84.jpg",
      address: "인천 서해 도동1길 5-3",
      description: "숲길과 바닷길이 아름다운 산책코스",
      rating: 4.8,
      category: "명소/놀거리", // 카테고리 지정
    ),
    // 추가 샘플 데이터
  ];

  List<SavedItem> getSavedItemsByCategory(String category) {
    // 카테고리별로 필터링된 항목 리스트 반환
    return _savedItems.where((item) => item.category == category).toList();
  }

  void updateItem(SavedItem item) {
    // 특정 아이템 업데이트
    final index = _savedItems.indexWhere((element) => element.title == item.title);
    if (index != -1) {
      _savedItems[index] = item;
    }
  }

  void toggleBookmark(SavedItem item) {
    // 북마크 상태를 토글
    item.isBookmarked = !item.isBookmarked;
    updateItem(item); // 변경된 상태를 저장
  }
}
