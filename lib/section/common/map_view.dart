import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapView extends StatefulWidget {
  final Function(NaverMapController)? onMapReady;

  const MapView({Key? key, this.onMapReady}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Completer<NaverMapController> _controller = Completer();
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeNaverMap();
  }

  // 네이버 지도 초기화 함수
  Future<void> _initializeNaverMap() async {
    WidgetsFlutterBinding.ensureInitialized();
    await NaverMapSdk.instance.initialize(
      clientId: 'tvzws5acgu', // 네이버 API 키를 입력하세요
      onAuthFailed: (e) {
        print('네이버맵 인증오류: $e');
      },
    );
  }

  // 네이버 지도 준비 완료 시 호출되는 함수
  void _onMapReady(NaverMapController controller) {
    _controller.complete(controller);
    if (widget.onMapReady != null) {
      widget.onMapReady!(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('네이버 지도 초기화 실패: ${snapshot.error}'));
        } else {
          return NaverMap(
            onMapReady: _onMapReady,
            options: const NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(36.2665, 127.7780),
                zoom: 6.2,
              ),
            ),
          );
        }
      },
    );
  }
}
