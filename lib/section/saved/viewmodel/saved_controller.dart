import 'package:flutter/material.dart';
import 'package:project_island/section/saved/model/saved_model.dart';
import 'package:project_island/section/saved/repository/saved_repository.dart';

class SavedController with ChangeNotifier {
  final SavedRepository repository = SavedRepository();

  Future<List<SavedItem>> getSavedItems(String category) async {
    // 카테고리에 해당하는 저장된 항목을 반환 (비동기 호출)
    return await repository.getSavedItemsByCategory(category); // 저장소에서 데이터를 가져옴
  }

  void toggleBookmark(SavedItem item) {
    repository.toggleBookmark(item);
    notifyListeners(); //UI 업데이트
  }
}
