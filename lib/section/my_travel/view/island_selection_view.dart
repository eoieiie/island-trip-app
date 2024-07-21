import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'travel_dates_view.dart';

class IslandSelectionView extends StatefulWidget {
  @override
  _IslandSelectionViewState createState() => _IslandSelectionViewState();
}

class _IslandSelectionViewState extends State<IslandSelectionView> {
  final Completer<NaverMapController> _controller = Completer();
  String _selectedIsland = '거제도';
  Future<void>? _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeNaverMap();
  }

  Future<void> _initializeNaverMap() async {
    WidgetsFlutterBinding.ensureInitialized();
    await NaverMapSdk.instance.initialize(
      clientId: 'tvzws5acgu',
      onAuthFailed: (e) {
        print('네이버맵 인증오류: $e');
      },
    );
  }

  void _onMapReady(NaverMapController controller) {
    _controller.complete(controller);

    final geojeMarker = NMarker(
      id: 'geoje',
      position: const NLatLng(34.8806, 128.6217),
    );
    final udoMarker = NMarker(
      id: 'udo',
      position: const NLatLng(33.5037, 126.5302),
    );
    final oedoMarker = NMarker(
      id: 'oedo',
      position: const NLatLng(34.6305, 128.6566),
    );
    final hongdoMarker = NMarker(
      id: 'hongdo',
      position: const NLatLng(34.6851, 125.1594),
    );
    final muuidoMarker = NMarker(
      id: 'muuido',
      position: const NLatLng(37.4519, 126.3947),
    );
    final jindoMarker = NMarker(
      id: 'jindo',
      position: const NLatLng(34.4887, 126.2630),
    );

    controller.addOverlayAll({
      geojeMarker, udoMarker, oedoMarker, hongdoMarker, muuidoMarker, jindoMarker
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('섬 선택'),
      ),
      body: FutureBuilder<void>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('네이버 지도 초기화 실패: ${snapshot.error}'));
          } else {
            return Column(
              children: [
                Expanded(
                  child: NaverMap(
                    onMapReady: _onMapReady,
                    options: NaverMapViewOptions(
                      initialCameraPosition: NCameraPosition(
                        target: NLatLng(35.9078, 127.7669), // 남한의 중심 좌표
                        zoom: 6.2,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TravelDatePage(selectedIsland: _selectedIsland),
                        ),
                      );
                    },
                    child: Text('$_selectedIsland로 결정하기!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
