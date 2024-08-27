import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../viewmodel/island_viewmodel.dart';
import '../model/island_model.dart';

class HomeMapView extends StatefulWidget {
  @override
  _HomeMapViewState createState() => _HomeMapViewState();
}

class _HomeMapViewState extends State<HomeMapView> {
  final Completer<NaverMapController> _controller = Completer();
  final IslandViewModel viewModel = Get.put(IslandViewModel());

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await NaverMapSdk.instance.initialize(
      clientId: dotenv.env['NAVER_MAP_CLIENT_ID']!,
      onAuthFailed: (e) {
        print('네이버맵 인증오류: $e');
      },
    );
    setState(() {});
  }

  void _onMapReady(NaverMapController controller) {
    _controller.complete(controller);
    _addMarkers(controller);
  }

  void _addMarkers(NaverMapController controller) {
    viewModel.islands.forEach((island) {
      final marker = NMarker(
        id: island.name,
        position: NLatLng(island.latitude - 0.2, island.longitude),
        caption: NOverlayCaption(
          text: island.name,
          textSize: 17,
          color: Colors.black87,
          haloColor: Colors.white,
        ),
        icon: NOverlayImage.fromAssetImage(
            // 'assets/icons/fishing.png'
            island.iconUrl
        ),
        size: Size(50, 50),
      );
      controller.addOverlay(marker);

      marker.setOnTapListener((overlay) {
        _showIslandDetails(island);
      });
    });
  }

  void _showIslandDetails(IslandModel island) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(island.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Tags: ${island.tags.join(', ')}', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            Image.asset(
              island.imageUrl,
              height: 150,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('섬 선택', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8), // 패딩 설정
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // 배경색 흰색
              borderRadius: BorderRadius.circular(12), // 둥근 모서리 설정
              boxShadow: [
                BoxShadow(
                  color: Colors.black26, // 그림자 색상
                  blurRadius: 3, // 그림자 흐림 정도
                  offset: Offset(0, 0), // 그림자 위치
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black), // 뒤로가기 아이콘
              onPressed: () {
                Navigator.pop(context); // 뒤로가기 기능
              },
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          NaverMap(
            onMapReady: _onMapReady,
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(36.0, 127.0),
                zoom: 6,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: () {
                // 여기서 리스트 보기를 추가
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
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
