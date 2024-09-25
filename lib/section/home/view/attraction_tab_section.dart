import 'package:flutter/material.dart';
import '../../common/google_api/viewmodels/google_place_view_model.dart';
import '../../common/google_api/models/google_place_model.dart';

class AttractionTabSection extends StatefulWidget {
  const AttractionTabSection({super.key});

  @override
  _AttractionTabSectionState createState() => _AttractionTabSectionState();
}

class _AttractionTabSectionState extends State<AttractionTabSection> {
  final GooglePlaceViewModel _placeViewModel = GooglePlaceViewModel(); // ViewModel 인스턴스 생성
  Map<String, List<Map<String, dynamic>>> _placesByCategory = {}; // 카테고리별 장소 저장
  final List<String> chainStores = ['디저트39', '스타벅스', '투썸플레이스', '북', '상회']; // 제외할 목록

  @override
  void initState() {
    super.initState();
    _fetchIslandData(); // 화면 초기화 시 API 호출
  }

  // 섬 데이터를 검색하는 함수
  Future<void> _fetchIslandData() async {
    List<String> islands = ['안면도', '울릉도', '영흥도', '거제도', '진도']; // 섬 목록
    List<String> categories = ['카페', '맛집', '낚시포인트', '문화재', '포토존/산책/자연']; // 카테고리 목록

    Map<String, List<Map<String, dynamic>>> fetchedPlaces = {};

    await Future.wait(categories.map((category) async {
      List<Map<String, dynamic>> categoryPlaces = [];

      // 각 섬에 대해 장소 정보 검색
      await Future.wait(islands.map((island) async {
        String query = '$island $category';
        List<GooglePlaceModel> places = await _placeViewModel.searchPlaces(query);

        // 필터링 조건 적용
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
      categoryPlaces.shuffle();
      fetchedPlaces[category] = categoryPlaces.take(15).toList();
    }));

    setState(() {
      _placesByCategory = fetchedPlaces;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = ['카페', '맛집', '낚시포인트', '문화재', '포토존/산책/자연'];

    // 섹션 제목을 감성적으로 변경한 맵핑
    Map<String, String> sectionTitles = {
      '카페': '감성을 채우는 카페',
      '맛집': '입맛을 사로잡는 맛집',
      '낚시포인트': '물고기가 가득한 낚시 포인트',
      '문화재': '역사가 숨쉬는 문화재',
      '포토존/산책/자연': '아름다운 자연과 포토존',
    };

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
          _buildCategorySection(category, sectionTitles[category]!),
          SizedBox(height: 20.0),
        ],
      ],
    );
  }

  // 카테고리 섹션을 생성하는 함수
  Widget _buildCategorySection(String category, String sectionTitle) {
    List<Map<String, dynamic>> categoryPlaces = _placesByCategory[category] ?? [];

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 섹션 제목 스타일 변경
            Text(
              sectionTitle,
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 16,
                fontFamily: 'Lobster',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10.0),
            // 가로 스크롤 그리드
            SizedBox(
              height: 200,
              child: categoryPlaces.isEmpty
                  ? Center(child: Text('$sectionTitle 데이터를 불러오는 중입니다...'))
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
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.33,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
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
                                // 섬 이름만 표시
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
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
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
          top: 110,
          child: FloatingActionButton(
            heroTag: 'attraction_$category',
            onPressed: () {
              // 카테고리별 전체 화면 보기
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryFullScreen(
                    category: category,
                    places: _placesByCategory[category] ?? [],
                    sectionTitle: sectionTitle,
                  ),
                ),
              );
            },
            child: Icon(Icons.arrow_forward),
            mini: true,
            backgroundColor: Colors.white.withOpacity(0.8),
            foregroundColor: Colors.black,
          ),
        ),
      ],
    );
  }
}

class CategoryFullScreen extends StatelessWidget {
  final String category;
  final String sectionTitle; // 섹션 제목 추가
  final List<Map<String, dynamic>> places;

  CategoryFullScreen({
    required this.category,
    required this.places,
    required this.sectionTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$sectionTitle 전체 보기'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black), // 뒤로가기 아이콘 색상 변경
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontFamily: 'Lobster',
          fontWeight: FontWeight.w400,
        ), // 타이틀 텍스트 스타일 수정
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0), // 패딩을 더 줌
        child: GridView.builder(
          itemCount: places.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 열의 개수를 2로 변경
            mainAxisSpacing: 12.0, // 수직 간격
            crossAxisSpacing: 12.0, // 수평 간격
            childAspectRatio: 0.75, // 아이템의 가로세로 비율 조정
          ),
          itemBuilder: (context, index) {
            final placeData = places[index];
            final GooglePlaceModel place = placeData['place'];
            final imageUrl = place.photoUrls?.isNotEmpty == true
                ? place.photoUrls!.first
                : null;
            final address = place.address ?? '주소 정보 없음';
            final String islandName = placeData['island'];

            return GestureDetector(
              onTap: () {
                // 상세 페이지로 이동하는 코드 추가 가능
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // 이미지 부분
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
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported),
                      ),
                    ),
                    // 이미지 위에 텍스트들
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
                          SizedBox(height: 2.0),
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
                          SizedBox(height: 2.0),
                          // 주소
                          Text(
                            address,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
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
                      top: 10.0,
                      right: 10.0,
                      child: place.rating != null
                          ? Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow, size: 14),
                          SizedBox(width: 2.0),
                          Text(
                            place.rating!.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 4.0,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ],
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
    );
  }
}
