import 'package:project_island/section/common/google_api/viewmodels/google_place_view_model.dart';
import 'package:project_island/section/common/google_api/models/google_place_model.dart';
import '../model/island_model.dart';

class IslandRepository {
  final GooglePlaceViewModel _googlePlaceViewModel = GooglePlaceViewModel(); // 구글 API 사용을 위한 ViewModel 인스턴스 생성
  List<IslandModel> _savedItems = []; // 저장된 항목들을 관리하는 리스트

  // 5개의 섬의 정보 (위도, 경도, 주소 앞부분 포함)
  final List<IslandModel> _fiveIslands = [
    IslandModel(name: '덕적도', latitude: 37.2100, longitude: 126.1157, address: '인천 옹진군 덕적면', imageUrl: '', iconUrl: '', tags: [], title: '', description: '', category: '', phone: '', website: '', rating: null, isOpenNow: null),
    IslandModel(name: '안면도', latitude: 36.5294, longitude: 126.3109, address: '충남 태안군 안면읍', imageUrl: '', iconUrl: '', tags: [], title: '', description: '', category: '', phone: '', website: '', rating: null, isOpenNow: null),
    IslandModel(name: '진도', latitude: 34.4869, longitude: 126.2639, address: '전남 진도군', imageUrl: '', iconUrl: '', tags: [], title: '', description: '', category: '', phone: '', website: '', rating: null, isOpenNow: null),
    IslandModel(name: '거제도', latitude: 34.8809, longitude: 128.6217, address: '경남 거제시', imageUrl: '', iconUrl: '', tags: [], title: '', description: '', category: '', phone: '', website: '', rating: null, isOpenNow: null),
    IslandModel(name: '울릉도', latitude: 37.4914, longitude: 130.9053, address: '경북 울릉군', imageUrl: '', iconUrl: '', tags: [], title: '', description: '', category: '', phone: '', website: '', rating: null, isOpenNow: null),
  ];

  // 5개의 섬 목록을 반환하는 메서드
  List<IslandModel> getFiveIslands() {
    return _fiveIslands;
  }

// 로컬 JSON 파일에서 섬 데이터를 로드하는 메서드
  Future<List<IslandModel>> loadIslands() async {
    return []; // 여기서는 빈 리스트 반환 (예제 목적)
  }

  // 카테고리에 따른 항목을 비동기로 가져오는 메서드
  Future<List<IslandModel>> getItemsByCategory(String category) async {
    List<GooglePlaceModel> places = await _googlePlaceViewModel.searchPlaces(category);

    // 각 섬의 주소 앞부분으로 필터링
    return places
        .where((place) =>
        _fiveIslands.any((island) => place.address.contains(island.address))) // 주소 앞부분으로 필터링
        .map((place) => IslandModel.fromGooglePlaceModel(place))
        .toList();
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




