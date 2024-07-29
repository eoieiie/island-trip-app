import 'package:flutter/material.dart';
import 'package:project_island/section/home/repository/home_repository.dart';
import 'package:project_island/section/home/model/home_model.dart';

class IslandDetailViewModel extends ChangeNotifier {
  final Repository _repository = Repository();

  IslandDetail? _island;
  IslandDetail? get island => _island;

  String _selectedCategory = '전체'; // 기본 카테고리 설정
  String get selectedCategory => _selectedCategory;

  List<Store> get filteredStores {
    if (_selectedCategory == '전체') {
      return _island?.stores ?? [];
    } else {
      return _repository.filterStoresByCategory(_island?.stores ?? [], _selectedCategory);
    }
  }

  List<Content> get filteredContents {
    if (_selectedCategory.isEmpty) {
      return _island?.contents ?? [];
    } else {
      return _island?.contents.where((content) => content.category == _selectedCategory).toList() ?? [];
    }
  }

  // 저장된 가게 목록
  final Set<String> _savedStores = {};
  Set<String> get savedStores => _savedStores;

  void fetchIslandDetails(String islandName) {
    _island = _repository.fetchIslandDetails(islandName);
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void addSavedStore(String storeName) {
    _savedStores.add(storeName);
    notifyListeners();
  }

  void removeSavedStore(String storeName) {
    _savedStores.remove(storeName);
    notifyListeners();
  }
}
