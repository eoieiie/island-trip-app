// viewmodels/home_view_model.dart
import 'package:flutter/material.dart';
import '../model/home_model.dart';
import '../repository/home_repository.dart';


class HomeViewModel extends ChangeNotifier {
  bool isLoading = true;
  List<Magazine> magazines = [];
  List<Content> contents = [];
  List<Content> fishingContents = [];
  List<Content> viewpointContents = [];
  List<Content> beachContents = [];

  final Repository repository;

  HomeViewModel(this.repository) {
    _fetchData();
  }

  void _fetchData() async {
    await Future.delayed(Duration(seconds: 2));
    magazines = repository.fetchMagazines();
    contents = repository.fetchContents();
    fishingContents = repository.fetchFishingContents();
    viewpointContents = repository.fetchViewpointContents();
    beachContents = repository.fetchBeachContents();
    isLoading = false;
    notifyListeners();
  }
}