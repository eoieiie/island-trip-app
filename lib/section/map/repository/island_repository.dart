import 'package:project_island/section/common/google_api/viewmodels/google_place_view_model.dart';
import 'package:project_island/section/common/google_api/models/google_place_model.dart';
import '../model/island_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart'; // 거리 계산을 위함
/////////nextPageToken을 관리
// IslandRepository.dart
class IslandCategoryData {
  List<IslandModel> islands = [];
  String? nextPageToken;
  bool isDataLoaded = false;

  IslandCategoryData({List<IslandModel>? islands, this.nextPageToken, this.isDataLoaded = false}) {
    if (islands != null) {
      this.islands = islands;
    }
  }
}
///////////////////
class IslandRepository {
  final GooglePlaceViewModel _googlePlaceViewModel = GooglePlaceViewModel(); // 구글 API 사용을 위한 ViewModel 인스턴스 생성

  // 카테고리별로 데이터를 캐싱하기 위한 맵
  final Map<String, List<IslandModel>> _categoryCache = {};


  // 각 섬의 좌표 정보
  final Map<String, List<double>> islandCoordinates = {
    '안면도': [36.4162, 126.3867],
    '거제도': [34.8803, 128.6217],
    '울릉도': [37.4803, 130.9055],
    '덕적도': [37.2138, 126.1344],
    '진도': [34.4800, 126.2600],
  };

  // 로컬 JSON 파일에서 섬 데이터를 로드하는 메서드
  Future<List<IslandModel>> loadIslands() async {
    final String response = await rootBundle.loadString('assets/data/island_data.json');
    final List<dynamic> data = jsonDecode(response);
    return data.map((json) => IslandModel.fromJson(json)).toList();
  }

  // 카테고리에 따른 섬(장소) 데이터를 가져오는 메서드
  Future<List<IslandModel>> getItemsByCategory(String category) async {

    String islandName = _extractIslandNameFromCategory(category);

    // 섬 이름으로 검색할 때는 캐시를 무시하고 항상 새 데이터를 가져오도록 처리
    bool forceRefresh = category == islandName;  // 카테고리와 섬 이름이 정확히 일치할 때만 true

    // 캐시에 데이터가 있으면 반환
    // 캐시에 데이터가 있고, 섬 이름 검색이 아니라면 캐시를 사용
    if (!forceRefresh && _categoryCache.containsKey(category)) {
      return _categoryCache[category]!;
    }


    List<GooglePlaceModel> places = [];

    // 만약 카테고리에 공백이 포함되어 있다면 (예: "거제도 카페"), 그대로 검색
    if (category.contains(' ')) {
      places = await _googlePlaceViewModel.searchPlaces(category);  // 수정된 부분
    } else {
      // 기존 카테고리별 분기 로직 유지
      if (category == '명소/놀거리') {
        final places1 = await _googlePlaceViewModel.searchPlaces('명소');
        final places2 = await _googlePlaceViewModel.searchPlaces('놀거리');
        places = [...places1, ...places2];
      } else if (category == '섬') {
        places = await _googlePlaceViewModel.searchPlaces('island');
      } else if (category == '음식') {
        places = await _googlePlaceViewModel.searchPlaces('음식점');
      } else if (category == '카페') {
        places = await _googlePlaceViewModel.searchPlaces('카페');
      } else if (category == '숙소') {
        places = await _googlePlaceViewModel.searchPlaces('숙박');
      } else {
        places = await _googlePlaceViewModel.searchPlaces(category);
      }
    }
//
    // 해당 섬의 좌표 가져오기
    List<double>? islandCoords = islandCoordinates[islandName];

    if (islandCoords == null) {
      return []; // 해당하는 섬이 없으면 빈 리스트 반환
    }

    // 좌표로 필터링: 섬의 좌표와 장소 좌표 간의 거리 계산
    List<GooglePlaceModel> filteredPlaces = places.where((place) {
      double distanceInMeters = Geolocator.distanceBetween(
        islandCoords[0], islandCoords[1], // 섬 좌표
        place.latitude ?? 0.0, place.longitude ?? 0.0, // 장소 좌표
      );
      return distanceInMeters <= 40000; // 10km 이내의 장소만 필터링
    }).toList();

    // 평점 순으로 정렬 (높은 평점이 상위에 오도록)
    filteredPlaces.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    //////////////////////////////추가 함
    // 필터링된 장소를 IslandModel로 변환하여 리스트로 저장
    List<IslandModel> islandModels = filteredPlaces.map((place) => IslandModel.fromGooglePlaceModel(place)).toList();

    // 캐시에 저장
    _categoryCache[category] = islandModels;

    // 리스트를 반환
    return islandModels;
//////////////////////////////////

    // 필터링된 장소를 IslandModel로 변환하여 반환
    // return filteredPlaces.map((place) => IslandModel.fromGooglePlaceModel(place)).toList();  /dead 코드라는데 지워도 되나.. 위에 함수(캐싱 넣을라고) 추가하고부터 쓸데없어졌나봄
  }

  // 섬 이름을 카테고리에서 추출하는 헬퍼 메서드
  String _extractIslandNameFromCategory(String category) {
    if (category.contains('안면도')) {
      return '안면도';
    } else if (category.contains('거제도')) {
      return '거제도';
    } else if (category.contains('울릉도')) {
      return '울릉도';
    } else if (category.contains('덕적도')) {
      return '덕적도';
    } else if (category.contains('진도')) {
      return '진도';
    }
    return ''; // 기본 값
  }
}