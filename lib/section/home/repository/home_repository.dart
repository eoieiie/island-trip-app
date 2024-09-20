import '../model/home_model.dart';
import 'dart:convert';  // JSON 파싱을 위해 필요
import 'package:http/http.dart' as http;  // HTTP 요청을 위해 필요
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';  // 로컬 JSON 파일을 불러오기 위해 필요

class Repository {

  // JSON 파일을 로드하고 Magazine1 목록을 반환하는 메서드
  Future<List<Magazine1>> fetchMagazinesFromJson() async {
    final String response = await rootBundle.loadString('assets/magazines.json');
    final List<dynamic> data = json.decode(response);

    // JSON 데이터를 Magazine1 객체의 목록으로 변환
    return data.map((json) => Magazine1.fromJson(json)).toList();
  }

  // 특정 섬 이름에 대한 매거진 데이터를 가져오는 메서드
  Future<List<Magazine1>> fetchMagazinesByIslandName(String islandName) async {
    List<Magazine1> magazines = await fetchMagazinesFromJson();

    // 섬 이름이 매거진 제목에 포함된 항목 필터링
    return magazines.where((magazine) => magazine.title.contains(islandName)).toList();
  }
  final String apiKey = dotenv.env['TOUR_API_KEY'] ?? ''; // 환경 변수에서 API 키 가져오기

  // 여러 섬의 매거진 데이터를 가져오는 함수
  Future<List<Magazine>> fetchMagazinesFromMultipleIslands(
      List<String> islandNames) async {
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
          address: item['addr1'], // address 필드를 설정
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
      case '안면도':
        return 125850;
      case '울릉도':
        return 126101;
      case '영흥도':
        return 127629;
      case '거제도':
        return 126972; // 예시 contentId
      case '진도':
        return 126307;
      default:
        return 0; // 기본 contentId, 또는 예외 처리
    }
  }

  // 섬 이름을 받아 매거진 데이터를 가져오는 함수
  Future<List<Magazine>> fetchMagazines(List<String> islandNames) async {
    try {
      // 여러 섬의 매거진 데이터를 가져오는 메서드를 호출
      List<Magazine> magazines = await fetchMagazinesFromMultipleIslands(islandNames);
      return magazines; // 가져온 매거진 데이터를 반환
    } catch (e) {
      print('Error fetching magazines: $e'); // 에러 처리
      return []; // 에러 발생 시 빈 리스트 반환
    }
  }


  // 더미 데이터 - 물속체험 목록
  List<Content> fetchContents() {
    return List.generate(20,
            (index) =>
            Content(title: '물속체험 $index',
                description: '물속체험 설명 $index',
                category: '물속체험'));
  }

  // 더미 데이터 - 크루즈 목록
  List<Content> fetchCruisetripContents() {
    return List.generate(20,
            (index) =>
            Content(title: '크루즈 여행 $index',
                description: '크루즈 여행 $index',
                category: '크루즈 여행'));
  }

  // 더미 데이터 - 낚시 콘텐츠 목록
  List<Content> fetchFishingContents() {
    return List.generate(20,
            (index) =>
            Content(
                title: '낚시 $index', description: '낚시 $index', category: '낚시'));
  }

  // 더미 데이터 - 전망대 콘텐츠 목록
  List<Content> fetchViewpointContents() {
    return List.generate(20,
            (index) =>
            Content(title: '전망대 $index',
                description: '전망대 설명 $index',
                category: '전망대'));
  }

  // 더미 데이터 - 포토존 콘텐츠 목록
  List<Content> fetchPhotozoneContents() {
    return List.generate(20,
            (index) =>
            Content(title: '포토존 $index',
                description: '포토존 설명 $index',
                category: '포토존'));
  }

  // 더미 데이터 - 특정 섬에 대한 세부 정보
  // 특정 섬에 대한 세부 정보 가져오기
  Future<IslandDetail> fetchIslandDetails(String islandName) async {
    final contentId = _getContentIdByIslandName(islandName);

    if (contentId == 0) {
      // contentId가 유효하지 않은 경우
      return IslandDetail(
        name: islandName,
        description: '$islandName는 아직 데이터가 준비되지 않았습니다...',
        magazines: [],
        reviews: [],
      );
    }

    try {
      // Fetching details from API
      final detailResponse = await http.get(
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

      if (detailResponse.statusCode == 200) {
        final data = jsonDecode(utf8.decode(detailResponse.bodyBytes));
        final item = data['response']['body']['items']['item'][0];

        return IslandDetail(
          name: islandName,
          description: item['overview'] ?? '설명 없음',
          magazines: await fetchMagazinesFromApi(islandName),
          reviews: item['reviews'] ?? [],
        );
      } else {
        throw Exception('Failed to load island details from API');
      }
    } catch (e) {
      print('Error fetching island details: $e');
      return IslandDetail(
        name: islandName,
        description: '$islandName는 아직 데이터가 준비되지 않았습니다...',
        magazines: [],
        reviews: [],
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

  Future<List<String>> fetchIslandImages(int contentId) async {
    final response = await http.get(
      Uri.parse('http://apis.data.go.kr/B551011/KorService1/detailImage1'
          '?ServiceKey=$apiKey'
          '&contentId=$contentId'
          '&MobileOS=ETC'
          '&MobileApp=AppTest'
          '&imageYN=Y'
          '&subImageYN=Y'
          '&numOfRows=10'
          '&_type=json'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)); // UTF-8로 디코딩
      final items = data['response']['body']['items']['item'] ?? [];

      List<String> imageUrls = [];
      for (var item in items) {
        imageUrls.add(
            item['originimgurl'] ?? ''); // 'originimgurl' 필드의 URL을 사용합니다
      }

      return imageUrls;
    } else {
      throw Exception('Failed to load images from API');
    }
  }
}