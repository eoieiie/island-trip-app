import 'package:project_island/section/common/google_api/viewmodels/google_place_view_model.dart';
import 'package:project_island/section/common/google_api/models/google_place_model.dart';
import '../model/island_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class IslandRepository {
  final GooglePlaceViewModel _googlePlaceViewModel = GooglePlaceViewModel(); // 구글 API 사용을 위한 ViewModel 인스턴스 생성
  List<IslandModel> _savedItems = []; // 저장된 항목들을 관리하는 리스트

  // 로컬 JSON 파일에서 섬 데이터를 로드하는 메서드
  Future<List<IslandModel>> loadIslands() async {
    final String response = await rootBundle.loadString('assets/data/island_data.json');
    final List<dynamic> data = jsonDecode(response);
    return data.map((json) => IslandModel.fromJson(json)).toList();
  }

  // 카테고리에 따른 섬(장소) 데이터를 가져오는 메서드
  Future<List<IslandModel>> getItemsByCategory(String category) async {
    List<GooglePlaceModel> places = [];

    // 카테고리에 따라 구글 API로 장소 검색
    if (category == '명소/놀거리') {
      final places1 = await _googlePlaceViewModel.searchPlaces('명소');
      final places2 = await _googlePlaceViewModel.searchPlaces('놀거리');
      places = [...places1, ...places2];
    } else if (category == '섬') {
      places = await _googlePlaceViewModel.searchPlaces('island'); // "섬" 검색
    } else if (category == '음식') {
      places = await _googlePlaceViewModel.searchPlaces('음식점');
    } else if (category == '카페') {
      places = await _googlePlaceViewModel.searchPlaces('카페');
    } else if (category == '숙소') {
      places = await _googlePlaceViewModel.searchPlaces('숙박');
    } else {
      places = await _googlePlaceViewModel.searchPlaces(category);
    }

    // 평점 순으로 정렬 (높은 평점이 상위에 오도록)
    places.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));

    // 필터링된 장소를 IslandModel로 변환
    return places.map((place) => IslandModel.fromGooglePlaceModel(place)).toList();
  }

  // 저장된 항목들을 반환하는 메서드
  Future<List<IslandModel>> getSavedItems() async {
    return _savedItems;
  }

  // 북마크 토글 기능
  void toggleBookmark(IslandModel item) {
    item.isBookmarked = !item.isBookmarked; // 북마크 상태 반전
    if (item.isBookmarked) {
      _savedItems.add(item); // 북마크가 활성화된 항목을 저장된 리스트에 추가
    } else {
      _savedItems.remove(item); // 북마크가 비활성화된 항목을 리스트에서 제거
    }
  }
}