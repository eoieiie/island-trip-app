import 'package:flutter/material.dart';
import 'package:project_island/section/map/model/island_model.dart';
import 'package:project_island/section/map/repository/island_repository.dart';

class HomemapListController with ChangeNotifier {
  final IslandRepository repository = IslandRepository(); // 저장소 인스턴스 생성

  // 카테고리에 따른 항목을 비동기로 가져오는 메서드
  Future<List<IslandModel>> getItemsByCategory(String category) async {
    return await repository.getItemsByCategory(category); // 저장소에서 데이터를 가져옴
  }

  // 북마크 토글 기능
  void toggleBookmark(IslandModel item) {
    repository.toggleBookmark(item); // 저장소에서 북마크 상태를 변경
    notifyListeners(); // UI 업데이트를 위해 변경 사항 알림
  }

  // 저장된 항목들을 가져오는 메서드
  Future<List<IslandModel>> getSavedItems() async {
    return await repository.getSavedItems(); // 저장된 항목들을 가져옴
  }
}
