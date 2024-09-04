import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../viewmodel/my_travel_viewmodel.dart';
import 'travel_dates_view.dart';
import 'package:project_island/section/map/model/island_model.dart';

class IslandSelectionView extends StatefulWidget {
  @override
  _IslandSelectionViewState createState() => _IslandSelectionViewState();
}

class _IslandSelectionViewState extends State<IslandSelectionView> {
  final Completer<NaverMapController> _controller = Completer();
  final MyTravelViewModel travelViewModel = Get.put(MyTravelViewModel());
  String _selectedIsland = '거제도'; // 기본 선택된 섬
  bool _isMapReady = false;
  IslandModel? _currentSelectedIsland; // 선택된 섬 정보
  List<IslandModel> islands = []; // JSON에서 불러온 섬 정보

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _loadIslandData(); // JSON 파일에서 섬 데이터를 불러옴
  }

  Future<void> _initializeMap() async {
    await NaverMapSdk.instance.initialize(
      clientId: dotenv.env['NAVER_MAP_CLIENT_ID']!,
      onAuthFailed: (e) {
        print('네이버맵 인증오류: $e');
      },
    );
    setState(() {
      _isMapReady = true;
    });
  }

  // JSON 파일에서 섬 데이터를 불러오는 함수
  Future<void> _loadIslandData() async {
    final String response = await rootBundle.loadString('assets/data/island_data.json');
    final List<dynamic> data = jsonDecode(response);
    setState(() {
      islands = data.map((island) => IslandModel.fromJson(island)).toList();
    });
  }

  // 맵이 준비되면 마커 추가
  void _onMapReady(NaverMapController controller) {
    _controller.complete(controller);
    _addMarkers(controller);
  }

  // 각 섬에 마커를 추가하는 함수
  void _addMarkers(NaverMapController controller) {
    islands.forEach((island) {
      final marker = NMarker(
        id: island.name,
        position: NLatLng(island.latitude, island.longitude), // 섬 위치
        caption: NOverlayCaption(
          text: island.name,
          textSize: 17,
          color: Colors.black87,
          haloColor: Colors.white,
        ),
        icon: NOverlayImage.fromAssetImage(island.iconUrl), // 섬 아이콘 설정
        size: Size(50, 50),
      );
      controller.addOverlay(marker);

      marker.setOnTapListener((overlay) {
        setState(() {
          _currentSelectedIsland = island; // 섬 클릭 시 선택된 섬 정보 업데이트
          _selectedIsland = island.name; // 하단 버튼의 섬 이름도 변경
        });
      });
    });
  }

  // 선택된 섬 정보 박스
  Widget _buildIslandInfoBox() {
    if (_currentSelectedIsland == null) return SizedBox.shrink(); // 선택된 섬이 없을 때는 빈 박스 반환

    return Container(
      padding: EdgeInsets.only(left: 16,right: 16, top: 4, bottom: 20),
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // 둥근 모서리
        boxShadow: [
          BoxShadow(
            color: Colors.black26, // 그림자 색상
            blurRadius: 5,         // 그림자 흐림 정도
            offset: Offset(0, 3),   // 그림자 위치
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0), // 이미지의 모서리를 둥글게 처리
            child: Image.asset(
              _currentSelectedIsland!.imageUrl, // 섬 이미지 URL
              height: 60,                       // 이미지 높이 설정
              width: 60,                        // 이미지 너비 설정
              fit: BoxFit.cover,                // 이미지를 박스 크기에 맞추기
            ),
          ),
          SizedBox(width: 12), // 이미지와 텍스트 간 간격 추가
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '396km · ${_currentSelectedIsland!.address}', // '이런 섬은 어때요?', // 설명 텍스트
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                // SizedBox(height: 1),
                Text(
                  _currentSelectedIsland!.name, // 섬 이름
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  '${_currentSelectedIsland!.tags.take(3).join(', ')}', // 섬의 거리와 위치 정보
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(width: 8), // 오른쪽 여백
        ],
      ),
    );
  }


  // UI 구성
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '',
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
                Navigator.pop(context); // 뒤로가기
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
              onMapReady: _onMapReady,
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: NLatLng(36.0, 127.0),
                  zoom: 6,
                ),
              ),
            )
                : Center(child: CircularProgressIndicator()), // 맵 준비 중
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 30.0, top: 0.0, right: 16.0, bottom: 10.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '어느 섬으로',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '여행을 떠나시나요?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '가고 싶은 섬을 선택해 주세요.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 60,// 상단에서 80px 아래에 위치
            left: 16,
            right: 16,
            child: _buildIslandInfoBox(), // 선택된 섬 정보 박스
          ),
          // 버튼 부분 수정

          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton.icon(
              // 선택된 섬에 따라 버튼의 동작과 스타일이 변경
              onPressed: () {
                if (_currentSelectedIsland != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TravelDatePage(selectedIsland: _selectedIsland),
                    ),
                  ).then((dates) {
                    if (dates != null) {
                      travelViewModel.addTravel(_selectedIsland, dates['startDate'], dates['endDate']);
                    }
                  });
                }
              },
              icon: Icon(
                Icons.map,
                color: Colors.white,
              ),
              // 섬이 선택되지 않았을 때는 '섬을 선택해주세요!' 문구를 표시
              label: Text(
                _currentSelectedIsland == null
                    ? '섬을 선택해주세요!' // 섬이 선택되지 않았을 때 표시되는 문구
                    : '$_selectedIsland로 결정하기!', // 섬이 선택되었을 때 표시되는 문구
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // 섬이 선택되지 않았을 때 회색으로, 선택되면 기본 색상으로 설정
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentSelectedIsland == null
                    ? Colors.grey // 섬이 선택되지 않았을 때 회색
                    : Color(0XFF1BB874), // 섬이 선택되었을 때는 초록색
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          /*
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: _currentSelectedIsland == null ? null : () { // 선택된 섬이 없으면 버튼 비활성화
                if (_currentSelectedIsland != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TravelDatePage(selectedIsland: _selectedIsland),
                    ),
                  ).then((dates) {
                    if (dates != null) {
                      travelViewModel.addTravel(_selectedIsland, dates['startDate'], dates['endDate']);
                    }
                  });
                }
              },
              icon: Icon(Icons.map, color: Colors.white),
              label: Text(
                _currentSelectedIsland == null // 선택된 섬이 없을 때
                    ? '섬을 선택해주세요!'  // 기본 상태의 텍스트
                    : '$_selectedIsland로 결정하기!', // 선택된 섬이 있을 때
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentSelectedIsland == null
                    ? Colors.white // 선택된 섬이 없을 때는 회색 비활성화 색
                    : Color(0XFF1BB874), // 선택된 섬이 있으면 원래 버튼 색상
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ), */
        ],
      ),
    );
  }
}
