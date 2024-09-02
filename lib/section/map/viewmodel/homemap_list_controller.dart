import 'package:flutter/material.dart';
import 'package:project_island/section/map/model/island_model.dart';
import 'package:project_island/section/map/repository/island_repository.dart';

class HomemapListController with ChangeNotifier {
  final IslandRepository repository = IslandRepository(); // 저장소 인스턴스 생성

  Future<List<IslandModel>> getItemsByCategory(String category) async {
    // 특정 카테고리에 해당하는 저장된 항목을 반환
    return await repository.getItemsByCategory(category);
  }

  void toggleBookmark(IslandModel item) {
    // 북마크 토글 기능
    repository.toggleBookmark(item); // 저장소에서 상태 변경
    notifyListeners(); // UI 업데이트
  }
}
