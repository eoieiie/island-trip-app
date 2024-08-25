// lib/section/my_travel/view/travel_schedule_view.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import '../viewmodel/my_travel_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_island/main.dart';
import 'schedule_add_view.dart';

class TravelScheduleView extends StatefulWidget {
  final String travelId;
  final String selectedIsland;
  final DateTime startDate;
  final DateTime endDate;

  TravelScheduleView({
    required this.travelId,
    required this.selectedIsland,
    required this.startDate,
    required this.endDate,
  });

  @override
  _TravelScheduleViewState createState() => _TravelScheduleViewState();
}

class _TravelScheduleViewState extends State<TravelScheduleView> {
  int _selectedIndex = 0;
  final Completer<NaverMapController> _controller = Completer();
  Future<void>? _initialization;
  int _selectedDayIndex = 0;
  late MyTravelViewModel travelViewModel;

  void _onItemTapped(int index) {
    if (index == 0) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(selectedIndex: index),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    travelViewModel = Get.find<MyTravelViewModel>();
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

  void _addSchedule(String title, String startTime, String endTime, String memo) {
    final selectedDate = widget.startDate.add(Duration(days: _selectedDayIndex));
    travelViewModel.addSchedule(
      travelId: widget.travelId,
      date: selectedDate,
      title: title,
      startTime: startTime,
      endTime: endTime,
      memo: memo,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '여행 일정',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIslandInfo(),
            _buildDaysTabBar(),
            _buildMap(),
            _buildDaySchedule(),
            _buildAddScheduleButton(),
            _buildAISuggestions(), // AI 추천 부분은 양옆 여백 없이
            _buildSavedPlaces(),
          ],
        ),
      ),
      // bottomNavigationBar: _buildBottomNavBar(), // 네비게이션바 생성하고자 하면 이 줄 주석 해제
    );
  }

  Widget _buildIslandInfo() {
    final travel = travelViewModel.travels.firstWhere((t) => t.id == widget.travelId);

    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              travel.imageUrl?.isNotEmpty == true
                  ? travel.imageUrl!
                  : 'assets/images/island.png',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/island.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  travel.island,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(width: 4),
                    Text(
                      "4.9",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "#천연기념물  #민가시산호류",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "${travel.startDate.year}.${travel.startDate.month.toString().padLeft(2, '0')}.${travel.startDate.day.toString().padLeft(2, '0')} ~ ${travel.endDate.year}.${travel.endDate.month.toString().padLeft(2, '0')}.${travel.endDate.day.toString().padLeft(2, '0')}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysTabBar() {
    // 시작 날짜와 종료 날짜 사이의 전체 날짜 목록을 생성합니다.
    final days = List.generate(
      widget.endDate.difference(widget.startDate).inDays + 1,
          (index) => widget.startDate.add(Duration(days: index)),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: Colors.white,
      height: 75, // 탭바의 높이를 지정
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // 가로 스크롤이 가능하도록 설정
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = _selectedDayIndex == index;
          final dayLabel = 'Day ${index + 1}';
          final dateLabel = '${day.month.toString().padLeft(2, '0')}.${day.day.toString().padLeft(2, '0')}';

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: Container(
              width: 100, // 버튼의 너비를 지정
              height: 0,
              margin: EdgeInsets.only(right: 8.0),
              padding: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                gradient: isSelected
                    ? LinearGradient(
                  begin: Alignment(0.60, -0.80),
                  end: Alignment(-0.6, 0.8),
                  colors: [Color(0xFF1BB874), Color(0xFF1BAEB8)],
                )
                    : null,
                color: isSelected ? null : Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: isSelected ? Colors.white.withOpacity(0.5) : Color(0xFFF7F7F7),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Color(0xFF999999),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    dateLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Color(0xFF666666),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildMap() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      height: 200,
      child: FutureBuilder<void>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('네이버 지도 초기화 실패: ${snapshot.error}'));
          } else {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: NaverMap(
                onMapReady: _onMapReady,
                options: const NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(36.0665, 127.2780),
                    zoom: 5.8,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildDaySchedule() {
    final schedules = travelViewModel.getSchedulesByDay(widget.travelId, _selectedDayIndex);

    return Column(
      children: schedules.map((schedule) {
        return _buildScheduleItem(
          schedule.title,
          "${schedule.startTime} ~ ${schedule.endTime}",
          schedule.memo ?? '',
        );
      }).toList(),
    );
  }

  Widget _buildScheduleItem(String place, String time, String memo) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
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

  Widget _buildAddScheduleButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScheduleAddView(
                    travelId: widget.travelId, // travelId 전달
                    selectedDate: widget.startDate.add(Duration(days: _selectedDayIndex)), // 선택된 날짜 전달
                    travelViewModel: travelViewModel,  // ViewModel 인스턴스 전달
                  ),
                ),
              );
              if (result == true) {
                await travelViewModel.loadSchedules(widget.travelId).then((_) {
                  setState(() {
                    // 이 부분에서 화면을 다시 빌드하여 추가된 일정을 반영합니다.
                  });
                });
              }
            },
            icon: Icon(Icons.add),
            label: Text('일정 추가'),
          ),
        ],
      ),
    );
  }

  Widget _buildAISuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('AI 추천', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('내 저장 장소', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
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
    return Stack(
      children: [
        BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/icon_calendar.svg',
                width: 24,
                height: 24,
                color: _selectedIndex == 0 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
              ),
              label: '일정',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/icon-search-mono.svg',
                width: 24,
                height: 24,
                color: _selectedIndex == 1 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
              ),
              label: '피드',
            ),
            BottomNavigationBarItem(
              icon: Container(),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/icon-stack-up-square-mono.svg',
                width: 24,
                height: 24,
                color: _selectedIndex == 3 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
              ),
              label: '저장',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/icon-user-mono.svg',
                width: 24,
                height: 24,
                color: _selectedIndex == 4 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
              ),
              label: '마이페이지',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
        Positioned(
          top: -30,
          left: MediaQuery.of(context).size.width / 2 - 50,
          child: GestureDetector(
            onTap: () => _onItemTapped(2),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [],
              ),
              child: Image.asset(
                'assets/images/icon_compass.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
      clipBehavior: Clip.none,
    );
  }
}
