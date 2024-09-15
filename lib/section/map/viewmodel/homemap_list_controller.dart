import 'package:flutter/material.dart';
import 'package:project_island/section/map/repository/island_repository.dart';
import 'package:project_island/section/map/model/island_model.dart';

class HomemapListController with ChangeNotifier {
  final IslandRepository repository = IslandRepository();

  // 5개의 섬 목록을 반환하는 메서드
  Future<List<IslandModel>> getFiveIslands() async {
    return await repository.getFiveIslands(); // 섬 목록을 반환하는 메서드 호출
  }

  // 카테고리에 따른 항목을 비동기로 가져오는 메서드
  Future<List<IslandModel>> getItemsByCategory(String category) async {
    final allItems = await repository.getItemsByCategory(category);

    // IslandRepository에 정의된 섬 목록을 참조하여 필터링
    final filteredItems = allItems.where((item) => repository.getFiveIslands().any((island) => island.name == item.name)).toList();

    return filteredItems;
  }

  // 북마크 상태를 토글하고 저장된 항목을 관리하는 메서드
  void toggleBookmark(IslandModel item) {
    repository.toggleBookmark(item);
    notifyListeners(); // UI 업데이트를 위해 변경 사항 알림
  }

  // 저장된 항목들을 가져오는 메서드
  Future<List<IslandModel>> getSavedItems() async {
    return await repository.getSavedItems();
  }
}
