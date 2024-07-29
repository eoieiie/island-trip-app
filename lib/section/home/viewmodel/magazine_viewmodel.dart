import 'package:flutter/material.dart';
import '../model/home_model.dart';
import '../repository/home_repository.dart';

class MagazineViewModel extends ChangeNotifier {
  final Repository repository;
  List<Magazine> magazines = [];
  List<Store> stores = [];

  MagazineViewModel({required this.repository});

  void fetchMagazines() {
    magazines = repository.fetchMagazines();
    notifyListeners();
  }

  void fetchStores() {
    stores = repository.fetchIslandDetails('울릉도').stores;
    notifyListeners();
  }
}
