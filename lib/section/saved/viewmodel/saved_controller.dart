import 'package:flutter/material.dart';
import 'package:project_island/section/saved/model/saved_model.dart';
import 'package:project_island/section/saved/repository/saved_repository.dart';

class SavedController with ChangeNotifier {
  final SavedRepository repository = SavedRepository();

  // 비동기 함수로 카테고리에 따라 저장된 항목을 가져옴
  Future<List<SavedItem>> getSavedItems(String category) async {
    return await repository.getSavedItemsByCategory(category);
  }

  // 북마크 상태를 토글하고 UI 업데이트를 알림
  void toggleBookmark(SavedItem item) {
    repository.toggleBookmark(item);
    notifyListeners();
  }
}
