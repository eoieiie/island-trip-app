import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class TravelScheduleView extends StatefulWidget {
  final String selectedIsland;
  final DateTime startDate;
  final DateTime endDate;

  TravelScheduleView({
    required this.selectedIsland,
    required this.startDate,
    required this.endDate,
  });

  @override
  _TravelScheduleViewState createState() => _TravelScheduleViewState();
}

class _TravelScheduleViewState extends State<TravelScheduleView> {
  final Completer<NaverMapController> _controller = Completer();
  Future<void>? _initialization;
  int _selectedDayIndex = 0;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeNaverMap();
  }

  Future<void> _initializeNaverMap() async {
    WidgetsFlutterBinding.ensureInitialized();
    await NaverMapSdk.instance.initialize(
      clientId: 'YOUR_NAVER_MAP_CLIENT_ID',
      onAuthFailed: (e) {
        print('네이버맵 인증오류: $e');
      },
    );
  }

  void _onMapReady(NaverMapController controller) {
    _controller.complete(controller);

    final marker1 = NMarker(
      id: '1',
      position: const NLatLng(37.5665, 126.9780),
    );
    final marker2 = NMarker(
      id: '2',
      position: const NLatLng(37.5765, 126.9880),
    );

    controller.addOverlayAll({marker1, marker2});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('여행 일정 짜기'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
      ),
      body: Stack(
        children: [
          _buildMap(),
          Column(
            children: [
              _buildIslandInfo(widget.selectedIsland, widget.startDate, widget.endDate),
              Expanded(child: _buildBottomSheet(context)),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildIslandInfo(String island, DateTime start, DateTime end) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            island,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          Text(
            "${start.year}.${start.month.toString().padLeft(2, '0')}.${start.day.toString().padLeft(2, '0')} ~ ${end.year}.${end.month.toString().padLeft(2, '0')}.${end.day.toString().padLeft(2, '0')}",
            style: TextStyle(fontSize: 16, color: Colors.blue.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('네이버 지도 초기화 실패: ${snapshot.error}'));
        } else {
          return NaverMap(
            onMapReady: _onMapReady,
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(37.5665, 126.9780), // 예시 좌표 (서울)
                zoom: 10,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      builder: (BuildContext context, ScrollController scrollController) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragUpdate: (details) {
            scrollController.position.moveTo(scrollController.position.pixels - details.primaryDelta!);
          },
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    scrollController.position.moveTo(scrollController.position.pixels - details.primaryDelta!);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, -1),
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildDaysTabBar(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      _buildDaySchedule(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDaysTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ChoiceChip(
            label: Text('Day ${index + 1}'),
            selected: _selectedDayIndex == index,
            selectedColor: Colors.blue,
            onSelected: (selected) {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            backgroundColor: Colors.blue.withOpacity(0.2),
            labelStyle: TextStyle(
              color: _selectedDayIndex == index ? Colors.white : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDaySchedule() {
    return Column(
      children: [
        _buildScheduleItem("호리네민박", "9:00 ~ 11:00", "메모"),
        _buildScheduleItem("식당", "11:00 ~ 12:00", ""),
        _buildAddPlaceButton(),
        _buildAISuggestions(),
        _buildSavedPlaces(),
      ],
    );
  }

  Widget _buildScheduleItem(String place, String time, String memo) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$place $time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          if (memo.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(memo, style: TextStyle(fontSize: 14)),
            ),
          Row(
            children: [
              _buildWhiteButton('교통편 보기', () {}),
              SizedBox(width: 10),
              _buildWhiteButton('메모 추가', () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteButton(String text, VoidCallback onPressed) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildAddPlaceButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add),
            label: Text('장소 추가'),
          ),
        ],
      ),
    );
  }

  Widget _buildAISuggestions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI 추천', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildAICard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAICard(int index) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[400],
              child: Center(child: Text('사진', style: TextStyle(fontSize: 16))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('장소명', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('별점: ★★★☆☆', style: TextStyle(fontSize: 12)),
                SizedBox(height: 2),
                Text('거리: 1.2km', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedPlaces() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('내 저장 장소', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildSavedPlaceCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedPlaceCard(int index) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[400],
              child: Center(child: Text('사진', style: TextStyle(fontSize: 16))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('장소명', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('별점: ★★★☆☆', style: TextStyle(fontSize: 12)),
                SizedBox(height: 2),
                Text('거리: 1.2km', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: '내 일정',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.travel_explore),
          label: '여행 도구',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '섬 모양 홈버튼',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.feed),
          label: '피드',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '마이페이지',
        ),
      ],
      currentIndex: 0, // 첫 번째 아이템 선택된 상태로 설정
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      onTap: (index) {
        // 네비게이션 동작 구현
      },
    );
  }
}
