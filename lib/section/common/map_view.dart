// lib/section/common/map_view.dart

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

  void _onMapReady(NaverMapController controller) {
    _controller.complete(controller);
    if (widget.onMapReady != null) {
      widget.onMapReady!(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NaverMap(
      onMapReady: _onMapReady,
      options: NaverMapViewOptions(
        initialCameraPosition: NCameraPosition(
          target: NLatLng(36.2665, 127.7780),
          zoom: 6.2,
        ),
      ),
    );
  }
}
