// lib/section/my_travel/view/travel_schedule_view.dart

import 'dart:async'; // 비동기 프로그래밍을 위한 라이브러리를 가져옵니다.
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 라이브러리를 가져옵니다.
import 'package:flutter_naver_map/flutter_naver_map.dart'; // 네이버 지도를 사용하기 위한 라이브러리를 가져옵니다.
import 'package:get/get.dart'; // GetX 라이브러리를 가져옵니다.
import '../viewmodel/my_travel_viewmodel.dart'; // MyTravelViewModel을 가져옵니다.
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_island/main.dart';


class TravelScheduleView extends StatefulWidget {
  final String travelId; // 여행 ID를 저장하는 변수

  TravelScheduleView({
    required this.travelId, required String selectedIsland, required DateTime startDate, required DateTime endDate, // 여행 ID를 필수 인자로 받습니다.
  });

  @override
  _TravelScheduleViewState createState() => _TravelScheduleViewState(); // 상태를 생성합니다.
}

class _TravelScheduleViewState extends State<TravelScheduleView> {
  int _selectedIndex = 0;
  final Completer<NaverMapController> _controller = Completer(); // NaverMapController를 완성합니다.
  Future<void>? _initialization; // 네이버 지도 초기화를 저장하는 변수
  int _selectedDayIndex = 0; // 선택된 날짜 인덱스를 저장하는 변수
  late MyTravelViewModel travelViewModel; // MyTravelViewModel 인스턴스 저장 변수


  void _onItemTapped(int index) {
    if (index == 0) {
      // 첫 번째 아이콘(현재 위치)에서는 현재 페이지 유지
      setState(() {
        _selectedIndex = index;
      });
    } else {
      // 다른 아이콘이 눌렸을 때 MainPage로 이동하면서 선택된 인덱스 전달
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
    travelViewModel = Get.find<MyTravelViewModel>(); // MyTravelViewModel 인스턴스를 가져옵니다.
    _initialization = _initializeNaverMap(); // 네이버 지도 초기화를 설정합니다.
  }

  Future<void> _initializeNaverMap() async {
    WidgetsFlutterBinding.ensureInitialized(); // Flutter 위젯 바인딩을 초기화합니다.
    await NaverMapSdk.instance.initialize(
      clientId: 'YOUR_NAVER_MAP_CLIENT_ID', // 네이버 지도 클라이언트 ID를 설정합니다.
      onAuthFailed: (e) {
        print('네이버맵 인증오류: $e'); // 인증 실패 시 오류 메시지를 출력합니다.
      },
    );
  }

  void _onMapReady(NaverMapController controller) {
    _controller.complete(controller); // NaverMapController를 완료합니다.

    final marker1 = NMarker(
      id: '1',
      position: const NLatLng(37.5665, 126.9780), // 예시 좌표 (서울)
    );
    final marker2 = NMarker(
      id: '2',
      position: const NLatLng(37.5765, 126.9880), // 예시 좌표 (서울)
    );

    controller.addOverlayAll({marker1, marker2}); // 지도에 마커 추가
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('여행 일정 짜기'), // 앱바 제목 설정
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(), // 뒤로 가기 버튼
        ),
        backgroundColor: Colors.white, // 앱바 배경 색상 설정
        iconTheme: IconThemeData(color: Colors.black), // 아이콘 색상 설정
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 18), // 제목 텍스트 스타일 설정
      ),
      body: Stack(
        children: [
          _buildMap(), // 네이버 지도 위젯
          Column(
            children: [
              _buildIslandInfo(), // 섬 정보 위젯
              Expanded(child: _buildBottomSheet(context)), // 바텀 시트 위젯
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(), // 바텀 네비게이션 바
    );
  }

  Widget _buildIslandInfo() {
    // 여행 ID를 사용해 TravelModel을 가져옵니다.
    final travel = travelViewModel.travels.firstWhere((t) => t.id == widget.travelId);

    return Container(
      color: Colors.white, // 배경 색상 설정
      width: double.infinity, // 너비를 화면 전체로 설정
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // 패딩 설정
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 정렬을 왼쪽으로 설정
        children: [
          Text(
            travel.island,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue), // 섬 이름 텍스트 스타일 설정
          ),
          Text(
            "${travel.startDate.year}.${travel.startDate.month.toString().padLeft(2, '0')}.${travel.startDate.day.toString().padLeft(2, '0')} ~ ${travel.endDate.year}.${travel.endDate.month.toString().padLeft(2, '0')}.${travel.endDate.day.toString().padLeft(2, '0')}",
            style: TextStyle(fontSize: 16, color: Colors.blue.withOpacity(0.7)), // 날짜 텍스트 스타일 설정
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FutureBuilder<void>(
      future: _initialization, // 네이버 지도 초기화 Future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // 초기화 중 로딩 인디케이터 표시
        } else if (snapshot.hasError) {
          return Center(child: Text('네이버 지도 초기화 실패: ${snapshot.error}')); // 초기화 실패 시 오류 메시지 표시
        } else {
          return NaverMap(
            onMapReady: _onMapReady, // 지도 준비 완료 시 호출되는 함수
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(37.5665, 126.9780), // 예시 좌표 (서울)
                zoom: 10, // 초기 줌 레벨 설정
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4, // 초기 크기 설정
      minChildSize: 0.2, // 최소 크기 설정
      maxChildSize: 0.8, // 최대 크기 설정
      builder: (BuildContext context, ScrollController scrollController) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque, // 투명한 부분도 터치 가능하도록 설정
          onVerticalDragUpdate: (details) {
            scrollController.position.moveTo(scrollController.position.pixels - details.primaryDelta!); // 드래그 업데이트
          },
          child: Container(
            color: Colors.white, // 배경 색상 설정
            child: Column(
              children: [
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    scrollController.position.moveTo(scrollController.position.pixels - details.primaryDelta!); // 드래그 업데이트
                  },
                  child: Container(
                    width: double.infinity, // 너비를 화면 전체로 설정
                    padding: const EdgeInsets.all(16.0), // 패딩 설정
                    decoration: BoxDecoration(
                      color: Colors.white, // 배경 색상 설정
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)), // 상단 모서리 둥글게 설정
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12, // 그림자 색상 설정
                          offset: Offset(0, -1), // 그림자 위치 설정
                          blurRadius: 5.0, // 그림자 블러 크기 설정
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300], // 색상 설정
                            borderRadius: BorderRadius.circular(10), // 모서리 둥글게 설정
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildDaysTabBar(), // 탭바 위젯
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController, // 스크롤 컨트롤러 설정
                    children: [
                      _buildDaySchedule(), // 일정 위젯
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
      mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ChoiceChip(
            label: Text('Day ${index + 1}'), // 탭 라벨 설정
            selected: _selectedDayIndex == index, // 선택된 상태 확인
            selectedColor: Colors.blue, // 선택된 탭 색상
            onSelected: (selected) {
              setState(() {
                _selectedDayIndex = index; // 선택된 탭 인덱스 업데이트
              });
            },
            backgroundColor: Colors.blue.withOpacity(0.2), // 배경 색상 설정
            labelStyle: TextStyle(
              color: _selectedDayIndex == index ? Colors.white : Colors.black, // 선택된 탭 텍스트 색상 설정
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDaySchedule() {
    return Column(
      children: [
        _buildScheduleItem("호리네민박", "9:00 ~ 11:00", "메모"), // 일정 항목
        _buildScheduleItem("식당", "11:00 ~ 12:00", ""), // 일정 항목
        _buildAddPlaceButton(), // 장소 추가 버튼
        _buildAISuggestions(), // AI 추천 섹션
        _buildSavedPlaces(), // 저장된 장소 섹션
      ],
    );
  }

  Widget _buildScheduleItem(String place, String time, String memo) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0), // 마진 설정
      padding: const EdgeInsets.all(8.0), // 패딩 설정
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!), // 테두리 설정
        borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게 설정
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 정렬을 왼쪽으로 설정
        children: [
          Text('$place $time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // 장소와 시간 텍스트 설정
          if (memo.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0), // 패딩 설정
              child: Text(memo, style: TextStyle(fontSize: 14)), // 메모 텍스트 설정
            ),
          Row(
            children: [
              _buildWhiteButton('교통편 보기', () {}), // 버튼 설정
              SizedBox(width: 10),
              _buildWhiteButton('메모 추가', () {}), // 버튼 설정
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteButton(String text, VoidCallback onPressed) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0), // 마진 설정
        child: TextButton(
          onPressed: onPressed, // 버튼 클릭 시 호출될 함수
          style: TextButton.styleFrom(
            backgroundColor: Colors.white, // 배경 색상 설정
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게 설정
              side: BorderSide(color: Colors.grey[300]!), // 테두리 색상 설정
            ),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.black), // 텍스트 색상 설정
          ),
        ),
      ),
    );
  }

  Widget _buildAddPlaceButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // 패딩 설정
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add), // 아이콘 설정
            label: Text('장소 추가'), // 라벨 설정
          ),
        ],
      ),
    );
  }

  Widget _buildAISuggestions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // 패딩 설정
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 정렬을 왼쪽으로 설정
        children: [
          Text('AI 추천', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // 섹션 제목 설정
          SizedBox(height: 10),
          Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // 가로 스크롤 설정
              itemCount: 5, // 아이템 개수
              itemBuilder: (context, index) {
                return _buildAICard(index); // AI 카드 위젯
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAICard(int index) {
    return Container(
      width: 150, // 너비 설정
      margin: EdgeInsets.only(right: 10), // 마진 설정
      decoration: BoxDecoration(
        color: Colors.grey[300], // 배경 색상 설정
        borderRadius: BorderRadius.circular(8), // 모서리 둥글게 설정
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 정렬을 왼쪽으로 설정
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[400], // 배경 색상 설정
              child: Center(child: Text('사진', style: TextStyle(fontSize: 16))), // 예시 텍스트
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0), // 패딩 설정
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 정렬을 왼쪽으로 설정
              children: [
                Text('장소명', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), // 장소명 텍스트 설정
                SizedBox(height: 4),
                Text('별점: ★★★☆☆', style: TextStyle(fontSize: 12)), // 별점 텍스트 설정
                SizedBox(height: 2),
                Text('거리: 1.2km', style: TextStyle(fontSize: 12)), // 거리 텍스트 설정
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedPlaces() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // 패딩 설정
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 정렬을 왼쪽으로 설정
        children: [
          Text('내 저장 장소', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // 섹션 제목 설정
          SizedBox(height: 10),
          Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // 가로 스크롤 설정
              itemCount: 5, // 아이템 개수
              itemBuilder: (context, index) {
                return _buildSavedPlaceCard(index); // 저장된 장소 카드 위젯
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedPlaceCard(int index) {
    return Container(
      width: 150, // 너비 설정
      margin: EdgeInsets.only(right: 10), // 마진 설정
      decoration: BoxDecoration(
        color: Colors.grey[300], // 배경 색상 설정
        borderRadius: BorderRadius.circular(8), // 모서리 둥글게 설정
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 정렬을 왼쪽으로 설정
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[400], // 배경 색상 설정
              child: Center(child: Text('사진', style: TextStyle(fontSize: 16))), // 예시 텍스트
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0), // 패딩 설정
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 정렬을 왼쪽으로 설정
              children: [
                Text('장소명', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), // 장소명 텍스트 설정
                SizedBox(height: 4),
                Text('별점: ★★★☆☆', style: TextStyle(fontSize: 12)), // 별점 텍스트 설정
                SizedBox(height: 2),
                Text('거리: 1.2km', style: TextStyle(fontSize: 12)), // 거리 텍스트 설정
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
                'assets/images/icon_calendar.svg', // SVG 이미지 경로
                width: 24,
                height: 24,
                color: _selectedIndex == 0 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
              ),
              label: '일정',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/icon-search-mono.svg', // SVG 이미지 경로
                width: 24,
                height: 24,
                color: _selectedIndex == 1 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
              ),
              label: '피드',
            ),
            BottomNavigationBarItem(
              icon: Container(), // 중앙 버튼은 Stack에서 따로 처리하므로 빈 컨테이너
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/icon-stack-up-square-mono.svg', // SVG 이미지 경로
                width: 24,
                height: 24,
                color: _selectedIndex == 3 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
              ),
              label: '저장',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/icon-user-mono.svg', // SVG 이미지 경로
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
          top: -30, // 이 값을 조정하여 중앙 아이콘의 높이를 설정하세요.
          left: MediaQuery.of(context).size.width / 2 - 50, // 아이콘 크기의 절반만큼 왼쪽으로 이동
          child: GestureDetector(
            onTap: () => _onItemTapped(2), // 중앙 버튼 탭 처리
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [],
              ),
              child: Image.asset(
                'assets/images/icon_compass.png', // PNG 이미지 경로
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
      clipBehavior: Clip.none, // 상단에 겹치는 아이콘이 잘리지 않도록 설정
    );
  }
}
