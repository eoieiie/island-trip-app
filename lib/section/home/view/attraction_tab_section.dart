import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/google_api/viewmodels/google_place_view_model.dart';
import '../../common/google_api/models/google_place_model.dart';

class AttractionTabSection extends StatefulWidget {
  @override
  _AttractionTabSectionState createState() => _AttractionTabSectionState();
}

class _AttractionTabSectionState extends State<AttractionTabSection> {
  final GooglePlaceViewModel _placeViewModel = GooglePlaceViewModel();  // ViewModel 인스턴스 생성
  Map<String, List<Map<String, dynamic>>> _placesByCategory = {};  // 카테고리별 장소 저장
  final List<String> chainStores = ['디저트39', '스타벅스', '투썸플레이스', '북', '상회'];  // 제외할 목록

  @override
  void initState() {
    super.initState();
    _fetchIslandData();  // 화면 초기화 시 API 호출
  }

  // 섬 데이터를 검색하는 함수 (섬 + 카테고리 조합으로 검색, 체인점 제외, 사진 있는 장소만 필터링)
  Future<void> _fetchIslandData() async {
    List<String> islands = ['안면도', '울릉도', '영흥도', '거제도', '진도'];  // 섬 목록
    List<String> categories = ['카페', '맛집', '낚시포인트', '문화재', '포토존/산책/자연'];  // 카테고리 목록

    Map<String, List<Map<String, dynamic>>> fetchedPlaces = {};

    await Future.wait(categories.map((category) async {
      List<Map<String, dynamic>> categoryPlaces = [];

      // 각 섬에 대해 장소 정보 검색
      await Future.wait(islands.map((island) async {
        String query = '$island $category';
        List<GooglePlaceModel> places = await _placeViewModel.searchPlaces(query);

        // 사진이 있고 체인점이 아닌 장소만 필터링, 별점 4.0 이상인 장소만 추가
        places = places.where((place) {
          final isNotChainStore = !chainStores.any((chain) => place.name.contains(chain));
          final hasPhotos = place.photoUrls != null && place.photoUrls!.isNotEmpty;
          final isRatingAbove4 = place.rating != null && place.rating! >= 4.0;
          return isNotChainStore && hasPhotos && isRatingAbove4;
        }).toList();

        // 각 장소에 섬 이름 추가
        for (var place in places) {
          categoryPlaces.add({'place': place, 'island': island});
        }
      }));

      // 무작위로 15개의 장소 선택
      categoryPlaces.shuffle();  // 리스트를 무작위로 섞음
      fetchedPlaces[category] = categoryPlaces.take(15).toList();  // 상위 15개만 저장
    }));

    setState(() {
      _placesByCategory = fetchedPlaces;  // 검색된 결과를 상태로 저장
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = ['카페', '맛집', '낚시포인트', '문화재', '포토존/산책/자연'];  // 카테고리 목록

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Attraction" 텍스트 추가
        Text(
          'Attraction',
          style: TextStyle(
            color: Color(0xFFC8C8C8),
            fontSize: 12,
            fontFamily: 'Lobster',
            fontWeight: FontWeight.w400,
            height: 0.11,
          ),
        ),
        SizedBox(height: 4.0),
        // 추천명소 타이틀
        Text(
          '추천 장소',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 18,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            height: 2,
          ),
        ),
        SizedBox(height: 16.0),
        // 각 카테고리별로 장소 그리드 표시
        for (String category in categories) ...[
          _buildCategorySection(category),
          SizedBox(height: 20.0),  // 카테고리 사이 간격
        ],
      ],
    );
  }

  // 카테고리 섹션을 생성하는 함수 (카테고리별로 장소 표시)
  Widget _buildCategorySection(String category) {
    List<Map<String, dynamic>> categoryPlaces = _placesByCategory[category] ?? [];

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카테고리 제목
            Text(
              category,
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            // 가로 스크롤 그리드
            SizedBox(
              height: 200,  // 고정된 높이로 가로 스크롤
              child: categoryPlaces.isEmpty
                  ? Center(child: Text('$category 데이터를 불러오는 중입니다...'))
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryPlaces.length,
                itemBuilder: (context, index) {
                  final placeData = categoryPlaces[index];
                  final GooglePlaceModel place = placeData['place'];
                  final String islandName = placeData['island'];
                  final imageUrl = place.photoUrls?.isNotEmpty == true
                      ? place.photoUrls!.first
                      : null;

                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Container(
                      width: 150,  // 카드의 너비
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // 장소 이미지
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: imageUrl != null
                                ? Image.network(
                              imageUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Icon(Icons.image_not_supported),
                            ),
                          ),
                          // 이미지 위에 텍스트(장소 이름, 섬 이름)
                          Positioned(
                            bottom: 10.0,
                            left: 10.0,
                            right: 10.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 장소 이름
                                Text(
                                  place.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 4.0,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.0),
                                // 섬 이름
                                Text(
                                  islandName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 4.0,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // 별점 표시
                          Positioned(
                            top: 170.0,
                            right: 10.0,
                            child: place.rating != null
                                ? Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow, size: 16),
                                SizedBox(width: 4.0),
                                Text(
                                  place.rating!.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,  // 글씨를 조금 더 눈에 띄게
                                  ),
                                ),
                              ],
                            )
                                : Container(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        // 오른쪽에 플로팅 버튼 추가
        Positioned(
          right: 0,
          top: 110,  // 그리드 높이 200의 절반에서 플로팅 버튼 높이의 절반(28)을 뺀 값
          child: FloatingActionButton(
            onPressed: () {
              // 카테고리별 전체 화면 보기
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryFullScreen(category: category, places: _placesByCategory[category] ?? []),
                ),
              );
            },
            child: Icon(Icons.arrow_forward),  // > 모양의 아이콘
            mini: true,  // 작은 크기의 플로팅 버튼
            backgroundColor: Colors.white.withOpacity(0.8),  // 버튼 색상 흰색에 투명도 적용
            foregroundColor: Colors.black,  // 아이콘 색상을 검정으로 설정
          ),
        ),
      ],
    );
  }
}

// 전체 화면으로 해당 카테고리의 장소들을 표시하는 페이지
class CategoryFullScreen extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> places;

  CategoryFullScreen({required this.category, required this.places});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category 전체 보기'),
      ),
      body: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          final placeData = places[index];
          final GooglePlaceModel place = placeData['place'];
          final imageUrl = place.photoUrls?.isNotEmpty == true
              ? place.photoUrls!.first
              : null;

          return ListTile(
            leading: imageUrl != null
                ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                : Icon(Icons.image_not_supported),
            title: Text(place.name),
            subtitle: Text('Rating: ${place.rating ?? "N/A"}'),
          );
        },
      ),
    );
  }
}
