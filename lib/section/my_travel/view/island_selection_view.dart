import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../../common/map_view.dart';
import 'travel_dates_view.dart';
import '../viewmodel/my_travel_viewmodel.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IslandSelectionView extends StatefulWidget {
  @override
  _IslandSelectionViewState createState() => _IslandSelectionViewState();
}

class _IslandSelectionViewState extends State<IslandSelectionView> {
  final Completer<NaverMapController> _controller = Completer();
  final MyTravelViewModel travelViewModel = Get.find<MyTravelViewModel>();
  String _selectedIsland = '거제도';
  bool _isMapReady = false;

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
    setState(() {
      _isMapReady = true;
    });
  }

  void _onMapReady(NaverMapController controller) {
    _controller.complete(controller);
    _addDefaultMarkers(controller);
  }

  void _addDefaultMarkers(NaverMapController controller) {
    final geojeMarker = NMarker(
      id: 'geoje',
      position: const NLatLng(34.8806, 128.6217),
      size: const Size(35, 35),
      caption: NOverlayCaption(
        text: '거제도',
        textSize: 15,
        color: Colors.black,
      ),
      icon: const NOverlayImage.fromAssetImage('assets/images/snorkeling.png'),
    );

    final udoMarker = NMarker(
      id: 'udo',
      position: const NLatLng(33.5037, 126.5302),
      size: const Size(35, 35),
      caption: NOverlayCaption(
        text: '우도',
        textSize: 15,
        color: Colors.black,
      ),
      icon: const NOverlayImage.fromAssetImage('assets/images/island.png'),
    );

    final oedoMarker = NMarker(
      id: 'oedo',
      position: const NLatLng(34.5805, 128.6566),
      size: const Size(35, 35),
      caption: NOverlayCaption(
        text: '외도',
        textSize: 15,
        color: Colors.black,
      ),
      icon: const NOverlayImage.fromAssetImage('assets/images/island.png'),
    );

    final hongdoMarker = NMarker(
      id: 'hongdo',
      position: const NLatLng(34.7851, 125.1594),
      size: const Size(35, 35),
      caption: NOverlayCaption(
        text: '홍도',
        textSize: 15,
        color: Colors.black,
      ),
      icon: const NOverlayImage.fromAssetImage('assets/images/island.png'),
    );

    final muuidoMarker = NMarker(
      id: 'muuido',
      position: const NLatLng(37.4519, 126.3947),
      size: const Size(35, 35),
      caption: NOverlayCaption(
        text: '무의도',
        textSize: 15,
        color: Colors.black,
      ),
      icon: const NOverlayImage.fromAssetImage('assets/images/island.png'),
    );

    final jindoMarker = NMarker(
      id: 'jindo',
      position: const NLatLng(34.4887, 126.2630),
      size: const Size(35, 35),
      caption: NOverlayCaption(
        text: '진도',
        textSize: 15,
        color: Colors.black,
      ),
      icon: const NOverlayImage.fromAssetImage('assets/images/snorkeling.png'),
    );

    controller.addOverlayAll({
      geojeMarker,
      udoMarker,
      oedoMarker,
      hongdoMarker,
      muuidoMarker,
      jindoMarker
    });

    geojeMarker.setOnTapListener((overlay) {
      setState(() {
        _selectedIsland = '거제도';
      });
    });
    udoMarker.setOnTapListener((overlay) {
      setState(() {
        _selectedIsland = '우도';
      });
    });
    oedoMarker.setOnTapListener((overlay) {
      setState(() {
        _selectedIsland = '외도';
      });
    });
    hongdoMarker.setOnTapListener((overlay) {
      setState(() {
        _selectedIsland = '홍도';
      });
    });
    muuidoMarker.setOnTapListener((overlay) {
      setState(() {
        _selectedIsland = '무의도';
      });
    });
    jindoMarker.setOnTapListener((overlay) {
      setState(() {
        _selectedIsland = '진도';
      });
    });
  }

  void _addTravel(String island, DateTime startDate, DateTime endDate) {
    travelViewModel.addTravel(island, startDate, endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(''),
      ),
      body: Stack(
        children: [
          // 지도 위젯
          Positioned.fill(
            child: _isMapReady
                ? MapView(onMapReady: _onMapReady)
                : Center(child: CircularProgressIndicator()),
          ),
          Positioned(
            top: 0, // 상단에 붙이기 위해 top을 0으로 설정
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 30.0, top: 0.0, right: 16.0, bottom: 10.0),
              color: Colors.white, // 배경을 하얀색으로 설정
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '어느 섬으로',
                    style: TextStyle(
                      fontSize: 24, // 큰 글씨 크기 설정
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '여행을 떠나시나요?',
                    style: TextStyle(
                      fontSize: 24, // 큰 글씨 크기 설정
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '가고 싶은 섬을 선택해 주세요..',
                    style: TextStyle(
                      fontSize: 13, // 설명 텍스트 크기 설정
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 플로팅 액션 버튼
          Positioned(
            bottom: 16.0,
            left: MediaQuery
                .of(context)
                .size
                .width / 2 - 165, // 버튼을 화면 중앙에 위치
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TravelDatePage(selectedIsland: _selectedIsland),
                  ),
                ).then((dates) {
                  if (dates != null) {
                    _addTravel(
                        _selectedIsland, dates['startDate'], dates['endDate']);
                  }
                });
              },
              icon: Icon(Icons.map, color: Colors.white),
              label: Text(
                '            $_selectedIsland로 결정하기!              ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Color(0XFF1BB874),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
