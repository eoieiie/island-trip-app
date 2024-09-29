import '../model/home_model.dart';
import 'dart:convert'; // JSON 파싱을 위해 필요
import 'package:http/http.dart' as http; // HTTP 요청을 위해 필요
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart'; // 로컬 JSON 파일을 불러오기 위해 필요
import 'package:xml/xml.dart' as xml;

// Repository: 외부 API 및 로컬 데이터를 사용해 데이터를 가져오는 클래스
// HomeViewModel과 상호작용하여 데이터를 제공
class Repository {
  final String apiKey = dotenv.env['TOUR_API_KEY'] ?? ''; // 환경 변수에서 API 키 가져오기

  // API에서 특정 콘텐츠 ID에 대한 썸네일 이미지를 가져오는 함수
  Future<String> fetchThumbnail(String contentId) async {
    final url =
        'http://apis.data.go.kr/B551011/KorService1/detailCommon1?ServiceKey=$apiKey&contentTypeId=12&contentId=$contentId&MobileOS=ETC&MobileApp=AppTest&defaultYN=Y&firstImageYN=Y&areacodeYN=Y&catcodeYN=Y&addrinfoYN=Y&mapinfoYN=Y&_type=json';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final body = data['response']['body'];

      if (body == null || body['items'] == null) {
        throw Exception('No items found in the response');
      }

      final items = body['items'];

      if (items is String) {
        print('Unexpected items structure: String');
        return ''; // 기본값 반환
      }

      final itemData = items['item'];

      if (itemData is List && itemData.isNotEmpty) {
        return itemData[0]['firstimage'] ?? ''; // 첫 번째 아이템의 썸네일 반환
      } else if (itemData is Map) {
        return itemData['firstimage'] ?? ''; // item이 맵일 경우 처리
      } else {
        throw Exception('Unexpected item data type');
      }
    } else {
      throw Exception('Failed to load thumbnail');
    }
  }

  // 섬 이름에 따라 대체 썸네일을 가져오는 함수
  Future<String> getFallbackThumbnail(String islandName) async {
    int contentId = 0;
    switch (islandName) {
      case '울릉도':
        contentId = 2614583;
        break;
      case '거제도':
        contentId = 126224;
        break;
      case '진도':
        contentId = 125851;
        break;
      default:
        contentId = 0;
    }

    if (contentId != 0) {
      return await fetchThumbnail(contentId.toString());
    } else {
      return ''; // 기본 이미지가 없는 경우 빈 문자열 반환
    }
  }

  // API에서 특정 콘텐츠 ID에 대한 이미지 URL 목록을 가져오는 함수
  Future<List<String>> fetchImageUrls(String contentId) async {
    final url =
        'http://apis.data.go.kr/B551011/KorService1/detailImage1?ServiceKey=$apiKey&contentId=$contentId&MobileOS=ETC&MobileApp=AppTest&imageYN=Y&subImageYN=Y&numOfRows=10';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);

      final urls = document.findAllElements('originimgurl').map((node) {
        return node.text;
      }).toList();

      return urls;
    } else {
      throw Exception('Failed to load image data');
    }
  }

  // 로컬 JSON 파일에서 매거진 데이터를 가져오는 함수
  Future<List<Magazine1>> fetchMagazinesFromJson() async {
    final String response = await rootBundle.loadString('assets/magazines.json');
    final List<dynamic> data = json.decode(response);

    return data.map((json) => Magazine1.fromJson(json)).toList();
  }

  // 섬 이름에 맞는 매거진 데이터를 필터링하여 가져오는 함수
  Future<List<Magazine1>> fetchMagazinesByIslandName(String islandName) async {
    List<Magazine1> magazines = await fetchMagazinesFromJson();
    return magazines.where((magazine) => magazine.title.contains(islandName)).toList();
  }

  // 여러 섬에 대해 API에서 매거진 데이터를 가져오는 함수
  Future<List<Magazine>> fetchMagazinesFromMultipleIslands(List<String> islandNames) async {
    List<Magazine> allMagazines = [];

    for (String islandName in islandNames) {
      List<Magazine> magazines = await fetchMagazinesFromApi(islandName);
      allMagazines.addAll(magazines);
    }

    return allMagazines;
  }

  // 특정 섬에 대한 매거진 데이터를 API에서 가져오는 함수
  Future<List<Magazine>> fetchMagazinesFromApi(String islandName) async {
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
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final items = data['response']['body']['items']['item'];

      List<Magazine> magazines = [];

      if (items is List) {
        for (var item in items) {
          magazines.add(Magazine(
            title: item['title'] ?? '제목 없음',
            description: item['overview'] ?? '설명 없음',
            hashtags: ['#여행', '#힐링', '#명소'],
            thumbnail: item['firstimage'] ?? '',
            address: item['addr1'],
          ));
        }
      } else if (items is Map) {
        magazines.add(Magazine(
          title: items['title'] ?? '제목 없음',
          description: items['overview'] ?? '설명 없음',
          hashtags: ['#여행', '#힐링', '#명소'],
          thumbnail: items['firstimage'] ?? '',
          address: items['addr1'],
        ));
      }

      return magazines;
    } else {
      throw Exception('Failed to load magazines from API');
    }
  }

  // 섬 이름에 맞는 contentId를 반환하는 헬퍼 함수
  int _getContentIdByIslandName(String islandName) {
    switch (islandName) {
      case '안면도':
        return 125850;
      case '울릉도':
        return 126101;
      case '영흥도':
        return 127629;
      case '거제도':
        return 126972;
      case '진도':
        return 126307;
      default:
        return 0;
    }
  }



  // 특정 섬에 대한 상세 정보를 가져오는 함수
  Future<IslandDetail> fetchIslandDetails(String islandName) async {
    final contentId = _getContentIdByIslandName(islandName);

    if (contentId == 0) {
      return IslandDetail(
        name: islandName,
        description: '$islandName는 아직 데이터가 준비되지 않았습니다...',
        magazines: [],
        reviews: [],
      );
    }

    try {
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
        final items = data['response']['body']['items']['item'];

        IslandDetail islandDetail;

        if (items is List && items.isNotEmpty) {
          final firstItem = items[0];
          islandDetail = IslandDetail(
            name: islandName,
            description: firstItem['overview'] ?? '설명 없음',
            magazines: await fetchMagazinesFromApi(islandName),
            reviews: firstItem['reviews'] ?? [],
          );
        } else if (items is Map) {
          islandDetail = IslandDetail(
            name: islandName,
            description: items['overview'] ?? '설명 없음',
            magazines: await fetchMagazinesFromApi(islandName),
            reviews: items['reviews'] ?? [],
          );
        } else {
          islandDetail = IslandDetail(
            name: islandName,
            description: '설명 없음',
            magazines: [],
            reviews: [],
          );
        }

        return islandDetail;
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


  // 특정 콘텐츠 ID에 대한 이미지 목록을 가져오는 함수
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
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final items = data['response']['body']['items']['item'] ?? [];

      List<String> imageUrls = [];
      for (var item in items) {
        imageUrls.add(item['originimgurl'] ?? '');
      }

      return imageUrls;
    } else {
      throw Exception('Failed to load images from API');
    }
  }
}
