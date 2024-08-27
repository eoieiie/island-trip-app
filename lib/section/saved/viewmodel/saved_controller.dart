import 'package:flutter/material.dart';
import 'package:project_island/section/saved/model/saved_model.dart';
import 'package:project_island/section/saved/repository/saved_repository.dart';

class SavedController with ChangeNotifier {
  final SavedRepository repository = SavedRepository(); // 저장소 인스턴스 생성

  List<SavedItem> getSavedItems(String category) {
    // 특정 카테고리에 해당하는 저장된 항목을 반환
    return repository.getSavedItemsByCategory(category);
  }

  void toggleBookmark(SavedItem item) {
    // 북마크 토글 기능
    repository.toggleBookmark(item); // 저장소에서 상태 변경
    notifyListeners(); // UI 업데이트
  }
}

