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
      iconTintColor: Colors.blue,
    );

    final udoMarker = NMarker(
      id: 'udo',
      position: const NLatLng(33.5037, 126.5302),
      iconTintColor: Colors.blue,
    );

    final oedoMarker = NMarker(
      id: 'oedo',
      position: const NLatLng(34.6305, 128.6566),
      iconTintColor: Colors.blue,
    );

    final hongdoMarker = NMarker(
      id: 'hongdo',
      position: const NLatLng(34.6851, 125.1594),
      iconTintColor: Colors.blue,
    );

    final muuidoMarker = NMarker(
      id: 'muuido',
      position: const NLatLng(37.4519, 126.3947),
      iconTintColor: Colors.blue,
    );

    final jindoMarker = NMarker(
      id: 'jindo',
      position: const NLatLng(34.4887, 126.2630),
      iconTintColor: Colors.blue,
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

  void _addTravel(String island, DateTime startDate, DateTime endDate) {
    travelViewModel.addTravel(island, startDate, endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('섬 선택'),
      ),
      body: _isMapReady
          ? Column(
        children: [
          Expanded(
            child: MapView(onMapReady: _onMapReady),
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
                ).then((dates) {
                  if (dates != null) {
                    _addTravel(_selectedIsland, dates['startDate'], dates['endDate']);
                  }
                });
              },
              child: Text(
                '$_selectedIsland로 결정하기!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ),
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
