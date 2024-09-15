import 'dart:async';
import 'dart:convert';  // jsonDecode 사용을 위한 import
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  // rootBundle 사용을 위한 import
import 'package:get/get.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_island/section/map/view/homemap_list.dart';
import '../viewmodel/island_viewmodel.dart';
import '../model/island_model.dart';
//import 'package:project_island/section/home/view/island_detail_view.dart';

class HomeMapView extends StatefulWidget {
  @override
  _HomeMapViewState createState() => _HomeMapViewState();
}

class _HomeMapViewState extends State<HomeMapView> {
  final Completer<NaverMapController> _controller = Completer();
  final IslandViewModel viewModel = Get.put(IslandViewModel());
  List<IslandModel> islands = []; // JSON에서 불러온 섬 정보
  IslandModel? _currentSelectedIsland; // 선택된 섬 정보
  String _selectedIsland = '거제도'; // 기본 선택된 섬
  bool _isMapReady = false; // 맵 준비 여부 확인
  String _selectedOption = '지도'; // 기본 선택 옵션을 '지도'로 설정
  bool _isExpanded = false; // 버튼이 확장된 상태로 시작

  @override
  void initState() {
    super.initState();
    _initializeMap();  // 네이버 맵 초기화
    _loadIslandData();  // JSON 파일에서 섬 데이터를 로드
  }

  // 네이버 맵 초기화
  Future<void> _initializeMap() async {
    await NaverMapSdk.instance.initialize(
      clientId: dotenv.env['NAVER_MAP_CLIENT_ID']!,
      onAuthFailed: (e) {
        print('네이버맵 인증오류: $e');
      },
    );
    setState(() {
      _isMapReady = true;  // 맵 준비 완료 시 상태 업데이트
    });
  }

  // JSON 파일에서 섬 데이터를 로드하는 함수
  Future<void> _loadIslandData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/island_data.json');  // JSON 파일 읽기
      final List<dynamic> data = jsonDecode(response);  // JSON 디코딩
      setState(() {
        islands = data.map((island) => IslandModel.fromJson(island)).toList();  // 섬 데이터 리스트로 변환
      });
    } catch (e) {
      print('Error loading JSON: $e');  // 오류 발생 시 출력
    }
  }

  // 맵이 준비되면 마커 추가
  void _onMapReady(NaverMapController controller) {
    _controller.complete(controller);
    _addMarkers(controller);  // 섬 위치에 마커 추가
  }

  // 각 섬에 마커를 추가하는 함수
  void _addMarkers(NaverMapController controller) {
    islands.forEach((island) {
      final marker = NMarker(
        id: island.name,
        position: NLatLng(island.latitude, island.longitude),  // 섬의 위도, 경도
        caption: NOverlayCaption(
          text: island.name,  // 섬 이름
          textSize: 17,
          color: Colors.black87,
          haloColor: Colors.white,
        ),
        icon: NOverlayImage.fromAssetImage(island.iconUrl),  // 섬 아이콘 설정
        size: Size(60, 60),
      );
      controller.addOverlay(marker);  // 마커 추가

      marker.setOnTapListener((overlay) {
        setState(() {
          _currentSelectedIsland = island;  // 섬 선택 시 섬 정보 업데이트
          _selectedIsland = island.name;  // 선택된 섬 이름 업데이트
        });
      });
    });
  }

  // 선택된 섬 정보 박스를 표시하는 함수
  Widget _buildIslandInfoBox() {
    if (_currentSelectedIsland == null) return SizedBox.shrink();  // 선택된 섬이 없을 때는 빈 박스 반환

    // 섬 이름에 따른 짧은 설명 작성
    String getIslandDescription(String islandName) {
      switch (islandName) {
        case '거제도':
          return '"여기가 한국이야?" 감성과 분위기가\n넘쳐 흐르는 꿈 같은 섬 🐚';
        case '안면도':
          return '로맨틱한 꽃 축제와 익스트림한 \n놀거리까지! 떠오르는 데이트 성지😘';
        case '덕적도':
          return '수도권에서 가볍게 떠나는 힐링 섬캉스, 프라이빗 바닷가 캠핑 명소🔥';
        case '진도':
          return '진도는 물회 맛집! 전통 시장 구경하고, 청정자연에서 몸도 마음도 refresh😚';
        case '울릉도':
          return '천혜의 자연이 살아숨쉬는 섬, 에메랄드빛 바다에서 즐기는 해양스포츠 명소🤿';
        default:
          return '🔧';
      }
    }

    return Container(
      padding: EdgeInsets.only(left: 12, right: 16, top: 12, bottom: 12),
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),  // 둥근 모서리
        boxShadow: [
          BoxShadow(
            color: Colors.black26,  // 그림자 색상
            blurRadius: 5,  // 그림자 흐림 정도
            offset: Offset(0, 3),  // 그림자 위치
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),  // 이미지의 모서리를 둥글게 처리
            child: Image.asset(
              _currentSelectedIsland!.imageUrl,  // 섬 이미지 URL
              height: 70,  // 이미지 높이
              width: 70,  // 이미지 너비
              fit: BoxFit.cover,  // 이미지 크기 조정
            ),
          ),
          SizedBox(width: 12),  // 이미지와 텍스트 간 간격 추가
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_currentSelectedIsland!.address}',  // 섬 거리 및 위치
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Row(
                  children: [
                    Text(
                      _currentSelectedIsland!.name,  // 섬 이름
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),  // 이름과 태그 간격 추가
                    Text(
                      '${_currentSelectedIsland!.tags.take(3).join(', ')}',  // 섬 해시태그
                      style: TextStyle(fontSize: 12, color: Colors.black38),
                    ),
                  ],
                ),
                // SizedBox(height: 4),
                Text(
                  getIslandDescription(_currentSelectedIsland!.name),  // 섬 이름에 따른 설명 표시
                  style: TextStyle(fontSize: 14, color: Color(0xFF606060)),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),  // 오른쪽 여백
        ],
      ),
    );
  }


  // 화면 외부를 터치하면 플로팅 버튼을 축소
  void _handleTapOutside() {
    if (_isExpanded) {
      setState(() {
        _isExpanded = false; // 버튼을 축소
      });
    }
  }

  // UI 구성
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent, // 투명한 영역도 감지
      onTap: _handleTapOutside, // 외부 터치 시 동작
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            '섬 선택',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);  // 뒤로 가기
                },
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            // 네이버 맵 표시
            Positioned.fill(
              child: _isMapReady
                  ? NaverMap(
                onMapReady: _onMapReady,  // 맵이 준비되면 실행
                options: NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(36.5, 128.45),  // 기본 카메라 위치
                    zoom: 5.7,  // 기본 줌 레벨
                  ),
                ),
              )
                  : Center(child: CircularProgressIndicator()),  // 맵 준비 중일 때 로딩 표시
            ),
            Positioned(
              top: 25,
              left: 12,
              right: 12,
              child: _buildIslandInfoBox(),  // 선택된 섬 정보 박스
            ),
          ],
        ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: 20, // 화면 아래로부터 30px 위치
              right: 5,  // 화면 왼쪽으로부터 40px 위치 (원하는 만큼 조절 가능)
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;  // 버튼 확장/축소 상태를 토글
                  });
                },
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200), // 애니메이션 속도 설정
                      width: _isExpanded ? 200 : 56, // 확장/축소 상태에 따른 너비 변경
                      height: 56, // 버튼 높이 조정
                      decoration: BoxDecoration(
                        color: Colors.white, // 축소 상태일 때도 배경색 유지
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!_isExpanded) // 축소 상태일 때는 아이콘만 표시
                            Icon(
                              _selectedOption == '지도' ? Icons.map : Icons.list, // 현재 선택된 옵션에 맞는 아이콘 표시
                              color: Colors.black,
                            ),
                          if (_isExpanded) ...[ // 확장 상태일 때는 버튼 전체를 표시
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (_selectedOption == '지도') {
                                    setState(() {
                                      _isExpanded = false; // '지도' 선택 시 축소
                                    });
                                  } else {
                                    setState(() {
                                      _selectedOption = '지도';
                                    });
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _selectedOption == '지도' ? Colors.black : Colors.white, // 선택 여부에 따른 배경색 변경
                                    borderRadius: BorderRadius.horizontal(left: Radius.circular(30)),
                                    border: Border.all(color: Colors.transparent), // 버튼 테두리
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.map,
                                        color: _selectedOption == '지도' ? Colors.white : Colors.black,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '지도',
                                        style: TextStyle(
                                          color: _selectedOption == '지도' ? Colors.white : Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: double.infinity, // 구분선
                              color: Colors.black,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedOption = '목록';
                                    Get.to(HomemapList()); // 목록 페이지로 이동
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _selectedOption == '목록' ? Colors.black : Colors.white,
                                    borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
                                    border: Border.all(color: Colors.transparent),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.list,
                                        color: _selectedOption == '목록' ? Colors.white : Colors.black,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '목록',
                                        style: TextStyle(
                                          color: _selectedOption == '목록' ? Colors.white : Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
