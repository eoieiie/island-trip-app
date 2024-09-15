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

    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 20),
      margin: EdgeInsets.symmetric(horizontal: 16.0),
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
              height: 60,  // 이미지 높이
              width: 60,  // 이미지 너비
              fit: BoxFit.cover,  // 이미지 크기 조정
            ),
          ),
          SizedBox(width: 12),  // 이미지와 텍스트 간 간격 추가
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '396km · ${_currentSelectedIsland!.address}',  // 섬 거리 및 위치
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  _currentSelectedIsland!.name,  // 섬 이름
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  '${_currentSelectedIsland!.tags.take(3).join(', ')}',  // 섬 해시태그
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),  // 오른쪽 여백
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
            bottom: 80,
            left: 12,
            right: 12,
            child: _buildIslandInfoBox(),  // 선택된 섬 정보 박스
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: () {
                Get.to(HomemapList());
              },
              icon: Icon(Icons.list, color: Colors.white),
              label: Text(
                '목록 보기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
