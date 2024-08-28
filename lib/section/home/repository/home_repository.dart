import '../model/home_model.dart';
import 'dart:convert';  // JSON 파싱을 위해 필요
import 'package:http/http.dart' as http;  // HTTP 요청을 위해 필요
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Repository {
  final String apiKey = dotenv.env['TOUR_API_KEY'] ?? '';  // 환경 변수에서 API 키 가져오기

  // 여러 섬의 매거진 데이터를 가져오는 함수
  Future<List<Magazine>> fetchMagazinesFromMultipleIslands(List<String> islandNames) async {
    List<Magazine> allMagazines = [];

    for (String islandName in islandNames) {
      List<Magazine> magazines = await fetchMagazinesFromApi(islandName);
      allMagazines.addAll(magazines);
    }

    return allMagazines;
  }

  // 실제 API에서 매거진 데이터를 가져오는 함수
  Future<List<Magazine>> fetchMagazinesFromApi(String islandName) async {
    // 섬에 따라 contentId를 다르게 설정
    int contentId = _getContentIdByIslandName(islandName);

    final response = await http.get(
      Uri.parse('http://apis.data.go.kr/B551011/KorService1/detailCommon1'
          '?ServiceKey=$apiKey'
          '&contentTypeId=12'
          '&contentId=$contentId'
          '&MobileOS=ETC'
          '&MobileApp=AppTest'
          '&defaultYN=Y'
          '&firstImageYN=Y'
          '&areacodeYN=Y'
          '&catcodeYN=Y'
          '&addrinfoYN=Y'
          '&mapinfoYN=Y'
          '&overviewYN=Y'
          '&_type=json'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)); // UTF-8로 디코딩
      final items = data['response']['body']['items']['item'];

      List<Magazine> magazines = [];
      for (var item in items) {
        magazines.add(Magazine(
          title: item['title'] ?? '제목 없음',
          description: item['overview'] ?? '설명 없음',
          hashtags: ['#여행', '#힐링', '#명소'],
          thumbnail: item['firstimage'] ?? '',
          address: item['addr1'],

        ));
      }

      return magazines;
    } else {
      throw Exception('Failed to load magazines from API');
    }
  }

  // 섬에 따라 contentId를 반환하는 함수
  int _getContentIdByIslandName(String islandName) {
    // 여기에 다른 섬의 contentId를 추가할 수 있습니다.
    switch (islandName) {
      case '거문도':
        return 126283;
      case '신시도':
        return 126293;  // 예시 contentId
      case '실미도':
        return 2767625;
    // 추가 섬에 대한 contentId를 여기에 추가
      case '장자도':
        return 126299;
      default:
        return 0;  // 기본 contentId, 또는 예외 처리
    }
  }

  // 더미 데이터 - 매거진 목록
  List<Magazine> fetchMagazines() {
    return [
      Magazine(
        title: '갈매기 까까, 울릉도',
        description: '사진 울릉도 고슴도치길 226-11',
        hashtags: ['#가성비', '#스쿠버다이빙', '#탁트인바다'],
        thumbnail: '', address: null,

      ),
      Magazine(
        title: '울릉도 여행의 모든 것',
        description: '울릉도의 숨은 명소들을 소개합니다.',
        hashtags: ['#여행', '#힐링', '#명소'],
        thumbnail: '', address: null,
      ),
    ];
  }

  // 더미 데이터 - 물속체험 목록
  List<Content> fetchContents() {
    return List.generate(20,
            (index) => Content(title: '물속체험 $index', description: '물속체험 설명 $index', category: '물속체험'));
  }

  // 더미 데이터 - 크루즈 목록
  List<Content> fetchCruisetripContents() {
    return List.generate(20,
            (index) => Content(title: '크루즈 여행 $index', description: '크루즈 여행 $index', category: '크루즈 여행'));
  }

  // 더미 데이터 - 낚시 콘텐츠 목록
  List<Content> fetchFishingContents() {
    return List.generate(20,
            (index) => Content(title: '낚시 $index', description: '낚시 $index', category: '낚시'));
  }

  // 더미 데이터 - 전망대 콘텐츠 목록
  List<Content> fetchViewpointContents() {
    return List.generate(20,
            (index) => Content(title: '전망대 $index', description: '전망대 설명 $index', category: '전망대'));
  }
// 더미 데이터 - 포토존 콘텐츠 목록
  List<Content> fetchPhotozoneContents(){
    return List.generate(20,
            (index) => Content(title: '포토존 $index', description: '포토존 설명 $index', category: '포토존'));
  }
  // 더미 데이터 - 특정 섬에 대한 세부 정보
  IslandDetail fetchIslandDetails(String islandName) {
    if (islandName == '울릉도') {
      return IslandDetail(
        name: '울릉도',
        description: '울릉도는 아름다운 자연과 다양한 액티비티를 즐길 수 있는 섬입니다.',
        magazines: fetchMagazines(),
        reviews: List.generate(10, (index) => '울릉도 후기 $index'),
        stores: [
          Store(name: '울릉도 한식 맛집 1', category: '한식', location: '울릉도 1', rating: 4.5),
          Store(name: '울릉도 중식 맛집 2', category: '중식', location: '울릉도 2', rating: 4.7),
          Store(name: '울릉도 일식 맛집 3', category: '일식', location: '울릉도 3', rating: 4.6),
          Store(name: '울릉도 양식 맛집 4', category: '양식', location: '울릉도 4', rating: 4.8),
          Store(name: '울릉도 카페 맛집 5', category: '카페', location: '울릉도 5', rating: 4.9),
          Store(name: '울릉도 한식 맛집 6', category: '한식', location: '울릉도 6', rating: 4.3),
          Store(name: '울릉도 중식 맛집 7', category: '중식', location: '울릉도 7', rating: 4.4),
          Store(name: '울릉도 일식 맛집 8', category: '일식', location: '울릉도 8', rating: 4.6),
          Store(name: '울릉도 양식 맛집 9', category: '양식', location: '울릉도 9', rating: 4.8),
          Store(name: '울릉도 카페 맛집 10', category: '카페', location: '울릉도 10', rating: 4.9),
        ],
        contents: fetchContents(),
      );
    } else {
      // 다른 섬 데이터 추가 가능
      return IslandDetail(
        name: islandName,
        description: '$islandName는 아직 데이터가 준비되지 않았습니다.',
        magazines: [],
        reviews: [],
        stores: [],
        contents: [],
      );
    }
  }

  // 카테고리별로 음식점 필터링
  List<Store> filterStoresByCategory(List<Store> stores, String category) {
    if (category == '전체') {
      return stores;
    }
    return stores.where((store) => store.category == category).toList();
  }

  // 음식점 이름으로 검색 필터링
  List<Store> filterStoresByName(List<Store> stores, String keyword) {
    return stores.where((store) => store.name.contains(keyword)).toList();
  }
}
