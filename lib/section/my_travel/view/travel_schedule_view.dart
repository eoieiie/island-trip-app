// 필요한 패키지를 가져옵니다.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import '../viewmodel/my_travel_viewmodel.dart';
import 'package:project_island/main.dart';
import 'schedule_add_view.dart';
import 'package:intl/intl.dart';

class TravelScheduleView extends StatefulWidget {
  final String travelId;
  final String selectedIsland;
  final DateTime startDate;
  final DateTime endDate;
  final double? latitude;
  final double? longitude;
  final List<String>? imageUrls;

  TravelScheduleView({
    required this.travelId,
    required this.selectedIsland,
    required this.startDate,
    required this.endDate,
    this.latitude,
    this.longitude,
    this.imageUrls,
  });

  @override
  _TravelScheduleViewState createState() => _TravelScheduleViewState();
}

class _TravelScheduleViewState extends State<TravelScheduleView> {
  int _selectedIndex = 0;
  final Completer<NaverMapController> _controllerCompleter = Completer();
  Future<void>? _initialization;
  int _selectedDayIndex = 0;
  late MyTravelViewModel travelViewModel;
  bool _showSavedPlaces = false;

  NaverMapController? _naverMapController; // NaverMapController를 상태 변수로 저장

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
    _controllerCompleter.complete(controller);
    _naverMapController = controller; // 컨트롤러를 상태 변수에 저장
    _updateMarkers(); // 지도 준비 완료 후 마커 업데이트
  }

  // 마커를 업데이트하는 함수
  void _updateMarkers() {
    if (_naverMapController == null) return;

    final schedules = travelViewModel.getSchedulesByDay(widget.travelId, _selectedDayIndex);
    List<NMarker> markers = [];

    for (var schedule in schedules) {
      if (schedule.latitude != null && schedule.longitude != null) {
        String iconPath;
        int scheduleIndex = schedules.indexOf(schedule) + 1;

        if (scheduleIndex >= 1 && scheduleIndex <= 10) {
          iconPath = 'assets/icons/_$scheduleIndex.png';
        } else {
          iconPath = 'assets/icons/_location.png';
        }

        final marker = NMarker(
          id: schedule.id,
          position: NLatLng(schedule.latitude!, schedule.longitude!),
          caption: NOverlayCaption(text: schedule.title),
          icon: NOverlayImage.fromAssetImage(iconPath),
        );
        markers.add(marker);
      }
    }

    // 모든 마커를 제거하고 새로 추가
    _naverMapController!.clearOverlays();
    _naverMapController!.addOverlayAll(markers.toSet());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 기존 코드 유지
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
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
                if (Navigator.of(context).canPop()) {
                  int count = 0;
                  Navigator.of(context).popUntil((route) {
                    return count++ == 3 || !Navigator.of(context).canPop();
                  });
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
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
            _buildSaveAndAddButtons(),
          ],
        ),
      ),
    );
  }

  // 기타 위젯 빌드 함수들은 기존 코드 유지
  // 섬 정보 표시 위젯을 만드는 함수
  Widget _buildIslandInfo() {
    final travel = travelViewModel.travels.firstWhere((t) => t.id == widget.travelId); // 여행 정보를 ViewModel에서 가져옴

    // 섬 이름에 따른 태그, 별점 및 이미지를 설정
    String imageUrl;
    List<String> tags;
    double rating;

    switch (travel.island) {
      case '영흥도':
        imageUrl = 'assets/icons/3dcamping.png';
        tags = ['#캠핑', '#해변', '#트레킹'];
        rating = 4.7;
        break;
      case '거제도':
        imageUrl = 'assets/icons/3dsurf.png';
        tags = ['#해양스포츠', '#스노쿨링', '#낚시', '#해변'];
        rating = 4.8;
        break;
      case '울릉도':
        imageUrl = 'assets/icons/3ddiving.png';
        tags = ['#스노쿨링', '#낚시', '#자연경관'];
        rating = 4.9;
        break;
      case '안면도':
        imageUrl = 'assets/icons/3dflower.png';
        tags = ['#꽃축제', '#액티비티', '#힐링'];
        rating = 4.6;
        break;
      case '진도':
        imageUrl = 'assets/icons/3dbluefish.png';
        tags = ['#물회', '#낚시', '#전통시장'];
        rating = 4.5;
        break;
      default:
        imageUrl = 'assets/icons/3disland.png'; // 기본 이미지 설정
        tags = ['#섬', '#자연'];
        rating = 4.0;
        break;
    }


    return Container(
      color: Colors.white, // 배경색 흰색
      width: double.infinity, // 가로로 꽉 채우기
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // 패딩 설정
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // 상단 정렬
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0), // 이미지 둥근 모서리 설정
            child: Image.asset(
              imageUrl, // 섬에 따른 이미지 경로
              width: 80,
              height: 80,
              fit: BoxFit.cover, // 이미지 크기 맞춤
            ),
          ),
          SizedBox(width: 16), // 이미지와 텍스트 사이 간격
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
              children: [
                Text(
                  travel.island, // 섬 이름 표시
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8), // 간격 설정
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20), // 별 아이콘
                    SizedBox(width: 4),
                    Text(
                      "$rating", // 별점 표시
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      tags.join(' '), // 해시태그 표시
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "${travel.startDate.year}.${travel.startDate.month.toString().padLeft(2, '0')}.${travel.startDate.day.toString().padLeft(2, '0')} ~ ${travel.endDate.year}.${travel.endDate.month.toString().padLeft(2, '0')}.${travel.endDate.day.toString().padLeft(2, '0')}", // 날짜 형식
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

  // 날짜 선택 탭바를 만드는 함수
  Widget _buildDaysTabBar() {
    final days = List.generate(
      widget.endDate.difference(widget.startDate).inDays + 1,
          (index) => widget.startDate.add(Duration(days: index)),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: Colors.white,
      height: 75,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
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
                _updateMarkers(); // 날짜 변경 시 마커 업데이트
              });
            },
            child: Container(
              width: 100,
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 네이버 지도 표시 위젯을 만드는 함수
  Widget _buildMap() {
    NLatLng initialPosition;
    double initialZoom;

    switch (widget.selectedIsland) {
      case '영흥도':
        initialPosition = NLatLng(37.2606, 126.4914);
        initialZoom = 10.2;
        break;
      case '거제도':
        initialPosition = NLatLng(34.8806, 128.6217);
        initialZoom = 9.0;
        break;
      case '울릉도':
        initialPosition = NLatLng(37.4986, 130.8655);
        initialZoom = 10.0;
        break;
      case '안면도':
        initialPosition = NLatLng(36.5062, 126.2967);
        initialZoom = 9.0;
        break;
      case '진도':
        initialPosition = NLatLng(34.4687, 126.2230);
        initialZoom = 8.8;
        break;
      default:
        initialPosition = NLatLng(36.0665, 127.2780);
        initialZoom = 5.8;
        break;
    }

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
                options: NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: initialPosition,
                    zoom: initialZoom,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // 일정 추가 버튼 및 저장 버튼을 생성하는 함수
  Widget _buildSaveAndAddButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScheduleAddView(
                travelId: widget.travelId,
                selectedDate: widget.startDate.add(Duration(days: _selectedDayIndex)),
                travelViewModel: travelViewModel,
                selectedIsland: widget.selectedIsland,
              ),
            ),
          );
          if (result == true) {
            await travelViewModel.loadSchedules(widget.travelId).then((_) {
              setState(() {
                _updateMarkers(); // 일정 추가 후 마커 업데이트
              });
            });
          }
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Color(0xFFE8E8E8)),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 12, color: Color(0xFF222222)),
              const SizedBox(width: 4),
              Text(
                '일정 추가',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 일정 리스트를 빌드하는 함수
  Widget _buildDaySchedule() {
    final schedules = travelViewModel.getSchedulesByDay(widget.travelId, _selectedDayIndex);

    return Column(
      children: List<Widget>.from(schedules.asMap().entries.map((entry) {
        final int scheduleIndex = entry.key + 1;
        final schedule = entry.value;
        return Dismissible(
          key: Key(schedule.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            travelViewModel.deleteSchedule(widget.travelId, schedule.id);
            setState(() {
              _updateMarkers(); // 일정 삭제 후 마커 업데이트
            });
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          child: _buildScheduleItem(
            schedule.title,
            "${schedule.startTime}",
            schedule.memo ?? '',
            scheduleIndex,
          ),
        );
      }).toList()),
    );
  }

  // 일정 아이템 위젯 생성 함수
  Widget _buildScheduleItem(String place, String time, String memo, int scheduleIndex) {
    DateTime parsedTime = DateTime.parse(time);
    String formattedTime = DateFormat('HH:mm').format(parsedTime);

    String iconPath;
    if (scheduleIndex >= 1 && scheduleIndex <= 10) {
      iconPath = 'assets/icons/_$scheduleIndex.png';
    } else {
      iconPath = 'assets/icons/_location.png';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Image.asset(
                iconPath,
                width: 20,
                height: 20,
              ),
              SizedBox(width: 8.0),
              Text(
                place,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8.0),
              Text(
                formattedTime,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          if (memo.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(memo, style: TextStyle(fontSize: 14)),
            ),
          /*
          Row(
            children: [
              _buildWhiteButton('수 정', () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScheduleAddView(
                      travelId: widget.travelId,
                      selectedDate: widget.startDate.add(Duration(days: _selectedDayIndex)),
                      travelViewModel: travelViewModel,
                      selectedIsland: widget.selectedIsland,
                      title: place,
                      startTime: time,
                      endTime: "23:59",
                      memo: memo,
                    ),
                  ),
                );
                if (result == true) {
                  await travelViewModel.loadSchedules(widget.travelId).then((_) {
                    setState(() {
                      _updateMarkers(); // 일정 수정 후 마커 업데이트
                    });
                  });
                }
              }),
            ],
          ),

           */
        ],
      ),
    );
  }

  // 흰색 버튼 스타일을 설정하는 함수
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
}
