// 네이버 지도 및 Flutter 관련 패키지를 가져옵니다.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import '../viewmodel/my_travel_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_island/main.dart';
import 'schedule_add_view.dart';
import 'package:intl/intl.dart';

// 여행 일정 화면을 위한 StatefulWidget 정의
class TravelScheduleView extends StatefulWidget {
  final String travelId; // 여행 ID
  final String selectedIsland; // 선택된 섬 이름
  final DateTime startDate; // 여행 시작일
  final DateTime endDate; // 여행 종료일
  final double? latitude; // 장소의 위도 (선택적)
  final double? longitude; // 장소의 경도 (선택적)
  final List<String>? imageUrls; // 이미지 URL 목록, 로컬 asset 이미지도 포함 가능 (선택적)


  // 생성자를 통해 필수 매개변수 초기화
  TravelScheduleView({
    required this.travelId,
    required this.selectedIsland,
    required this.startDate,
    required this.endDate,
    this.latitude, // 선택적, 기본값 없음
    this.longitude, // 선택적, 기본값 없음
    this.imageUrls, // 선택적, 기본값 없음
  });

  // State를 생성하는 메서드
  @override
  _TravelScheduleViewState createState() => _TravelScheduleViewState();
}

// 여행 일정 화면의 State 관리 클래스
class _TravelScheduleViewState extends State<TravelScheduleView> {
  int _selectedIndex = 0; // 현재 선택된 하단 네비게이션 인덱스
  final Completer<NaverMapController> _controller = Completer(); // 네이버 지도 컨트롤러를 위한 Completer
  Future<void>? _initialization; // 네이버 지도 초기화 작업을 위한 Future
  int _selectedDayIndex = 0; // 현재 선택된 Day의 인덱스
  late MyTravelViewModel travelViewModel; // 여행 데이터 ViewModel
  bool _showSavedPlaces = false;

  // 하단 네비게이션바에서 아이템 선택 시 호출되는 함수
  void _onItemTapped(int index) {
    if (index == 0) {
      setState(() {
        _selectedIndex = index; // 선택된 인덱스 업데이트
      });
    } else {
      // 메인 페이지로 이동
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
    travelViewModel = Get.find<MyTravelViewModel>(); // ViewModel 가져오기
    _initialization = _initializeNaverMap(); // 네이버 지도 초기화 작업 설정
  }

  // 네이버 지도 초기화 함수
  Future<void> _initializeNaverMap() async {
    WidgetsFlutterBinding.ensureInitialized();
    await NaverMapSdk.instance.initialize(
      clientId: 'YOUR_NAVER_MAP_CLIENT_ID', // 클라이언트 ID 설정
      onAuthFailed: (e) {
        print('네이버맵 인증오류: $e'); // 인증 실패 시 로그 출력
      },
    );
  }

  // 네이버 지도 준비 완료 시 호출되는 함수
  void _onMapReady(NaverMapController controller) {
    _controller.complete(controller); // 컨트롤러를 Completer로 전달

    // 여행 일정에서 좌표가 있는 일정에 대해 마커 생성
    final schedules = travelViewModel.getSchedulesByDay(widget.travelId, _selectedDayIndex); // 일정 목록 가져오기
    List<NMarker> markers = [];

    for (var schedule in schedules) {
      if (schedule.latitude != null && schedule.longitude != null) {
        // 숫자에 따른 이모티콘 이미지 경로 설정
        String iconPath;
        int scheduleIndex = schedules.indexOf(schedule) + 1;

        if (scheduleIndex >= 1 && scheduleIndex <= 10) {
          iconPath = 'assets/icons/_$scheduleIndex.png'; // 1부터 10까지의 숫자 이모티콘
        } else {
          iconPath = 'assets/icons/_location.png'; // 디폴트 이미지
        }

        // 좌표가 있는 경우 마커 생성
        final marker = NMarker(
          id: schedule.title, // 일정 제목을 마커 ID로 사용
          position: NLatLng(schedule.latitude!, schedule.longitude!), // 일정의 위도와 경도를 위치로 설정
          caption: NOverlayCaption(text: schedule.title), // 일정 제목을 마커 캡션으로 표시
          icon: NOverlayImage.fromAssetImage(iconPath), // 마커 이미지 설정
        );
        markers.add(marker); // 마커 리스트에 추가
      }
    }
    // 새로운 핑 (거제도 좌표에 마커 추가)
    final exampleMarker = NMarker(
      id: 'Example Marker',
      position: NLatLng(34.8806, 128.6217), // 거제도 좌표
      caption: NOverlayCaption(text: '거제도'),
    );
    markers.add(exampleMarker);


    // 생성된 모든 마커 지도에 추가
    controller.addOverlayAll(markers.toSet());
  }


  // 새로운 일정을 추가하는 함수
  void _addSchedule(String title, String startTime, String endTime, String memo) {
    final selectedDate = widget.startDate.add(Duration(days: _selectedDayIndex)); // 선택된 날짜 계산
    // ViewModel을 통해 일정 추가
    travelViewModel.addSchedule(
      travelId: widget.travelId,
      date: selectedDate,
      title: title,
      startTime: startTime,
      endTime: endTime,
      memo: memo,
    );
    setState(() {}); // 화면 갱신
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // 앱바 배경색 흰색
        scrolledUnderElevation: 0,
        elevation: 0, // 그림자 없애기
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8), // 앱바 왼쪽 패딩 설정
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // 버튼 배경색 흰색
              borderRadius: BorderRadius.circular(12), // 모서리 둥글게
              boxShadow: [
                BoxShadow(
                  color: Colors.black26, // 그림자 색상 설정
                  blurRadius: 3, // 그림자 흐림 정도
                  offset: Offset(0, 0), // 그림자 위치
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black), // 뒤로가기 아이콘
              onPressed: () {
                // 스택에 남은 페이지가 있으면 3번까지 pop
                if (Navigator.of(context).canPop()) {
                  int count = 0;
                  Navigator.of(context).popUntil((route) {
                    return count++ == 3 || !Navigator.of(context).canPop(); // 3번까지 pop 또는 갈 곳이 없을 때 멈춤
                  });
                } else {
                  Navigator.of(context).pop(); // pop이 불가능하면 한 번 pop
                }
              },
            ),
          ),
        ),
        title: Text(
          '여행 일정', // 앱바 제목
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // 제목 중앙 정렬
      ),
      backgroundColor: Colors.white, // 배경색 흰색
      body: SingleChildScrollView( // 스크롤 가능한 화면
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            _buildIslandInfo(), // 섬 정보 표시 위젯
            _buildDaysTabBar(), // 날짜 선택 탭바 표시
            _buildMap(), // 네이버 지도 표시 위젯
            _buildDaySchedule(), // 일자별 일정 표시 위젯
            // _buildAddScheduleButton(), // 일정 추가 버튼 표시
            _buildSaveAndAddButtons(), // 좌우 버튼
            // _buildSavedPlaces(), // 내 저장 장소 리스트
            // _buildAISuggestions(), // AI 추천 섹션
            // _buildSavedPlaces(), // 저장된 장소 섹션
          ],
        ),
      ),
    );
  }

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
      widget.endDate.difference(widget.startDate).inDays + 1, // 시작일과 종료일 차이로 날짜 목록 생성
          (index) => widget.startDate.add(Duration(days: index)), // 날짜 리스트 생성
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // 패딩 설정
      color: Colors.white, // 배경색 흰색
      height: 75, // 탭바 높이
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // 가로 스크롤 설정
        itemCount: days.length, // 날짜 개수
        itemBuilder: (context, index) {
          final day = days[index]; // 현재 날짜
          final isSelected = _selectedDayIndex == index; // 현재 선택된 날짜인지 확인
          final dayLabel = 'Day ${index + 1}'; // Day 레이블
          final dateLabel = '${day.month.toString().padLeft(2, '0')}.${day.day.toString().padLeft(2, '0')}'; // 날짜 레이블

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index; // 선택된 날짜 업데이트
              });
            },
            child: Container(
              width: 100, // 각 버튼의 너비
              margin: EdgeInsets.only(right: 8.0), // 버튼 사이 간격
              padding: const EdgeInsets.all(8), // 패딩 설정
              decoration: ShapeDecoration(
                gradient: isSelected // 선택된 버튼에 그라데이션 적용
                    ? LinearGradient(
                  begin: Alignment(0.60, -0.80),
                  end: Alignment(-0.6, 0.8),
                  colors: [Color(0xFF1BB874), Color(0xFF1BAEB8)], // 그라데이션 색상
                )
                    : null,
                color: isSelected ? null : Colors.white, // 선택되지 않은 경우 배경색 흰색
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: isSelected ? Colors.white.withOpacity(0.5) : Color(0xFFF7F7F7), // 선택 상태에 따른 테두리 색상
                  ),
                  borderRadius: BorderRadius.circular(8), // 둥근 모서리
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                children: [
                  Text(
                    dayLabel, // Day 레이블
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Color(0xFF999999), // 선택 상태에 따른 텍스트 색상
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 3), // 간격
                  Text(
                    dateLabel, // 날짜 레이블
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Color(0xFF666666), // 선택 상태에 따른 날짜 색상
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
// 네이버 지도 표시 위젯을 만드는 함수
  Widget _buildMap() {
    // 섬에 따른 초기 카메라 위치와 줌 레벨을 설정하는 변수
    NLatLng initialPosition;
    double initialZoom;

    // 섬 이름에 따른 지도 초기 위치와 줌 레벨을 설정
    switch (widget.selectedIsland) {
      case '영흥도':
        initialPosition = NLatLng(37.2606, 126.4914); // 영흥도 좌표
        initialZoom = 10.2; // 줌 레벨
        break;
      case '거제도':
        initialPosition = NLatLng(34.8806, 128.6217); // 거제도 좌표
        initialZoom = 9.0;
        break;
      case '울릉도':
        initialPosition = NLatLng(37.4986, 130.8655); // 울릉도 좌표
        initialZoom = 10.0;
        break;
      case '안면도':
        initialPosition = NLatLng(36.5062, 126.2967); // 안면도 좌표
        initialZoom = 9.0;
        break;
      case '진도':
        initialPosition = NLatLng(34.4687, 126.2230); // 진도 좌표
        initialZoom = 8.8;
        break;
      default:
        initialPosition = NLatLng(36.0665, 127.2780); // 기본 위치 (서울)
        initialZoom = 5.8;
        break;
    }


    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), // 패딩 설정
      height: 200, // 지도 높이
      child: FutureBuilder<void>(
        future: _initialization, // 지도 초기화 작업
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // 로딩 중일 때 스피너 표시
          } else if (snapshot.hasError) {
            return Center(child: Text('네이버 지도 초기화 실패: ${snapshot.error}')); // 에러 발생 시 에러 메시지 표시
          } else {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12.0), // 지도 모서리 둥글게
              child: NaverMap(
                onMapReady: _onMapReady, // 지도 준비 완료 시 호출되는 함수
                options: NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: initialPosition, // 섬에 따른 초기 위치 설정
                    zoom: initialZoom, // 섬에 따른 줌 레벨 설정
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // 일자별 일정 표시를 위한 함수
  Widget _buildDaySchedule() {
    final schedules = travelViewModel.getSchedulesByDay(widget.travelId, _selectedDayIndex); // 선택된 날짜의 일정 가져오기

    return Column(
      children: List<Widget>.from(schedules.asMap().entries.map((entry) {
        final int scheduleIndex = entry.key + 1; // 1부터 시작하는 일정 순서
        final schedule = entry.value;
        return Dismissible(
          key: Key(schedule.id), // scheduleId로 고유 키 설정
          direction: DismissDirection.endToStart, // 오른쪽에서 왼쪽으로 스와이프
          onDismissed: (direction) {
            travelViewModel.deleteSchedule(widget.travelId, schedule.id); // 스케줄 삭제
          },
          background: Container(
            color: Colors.red, // 삭제 시 배경색
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.delete, color: Colors.white), // 삭제 아이콘
          ),
          child: _buildScheduleItem(
            schedule.title,
            "${schedule.startTime}",
            schedule.memo ?? '',
            scheduleIndex,  // 추가된 인수
          ),
        );
      }).toList()),
    );
  }

  Widget _buildScheduleItem(String place, String time, String memo, int scheduleIndex) {
    // String을 DateTime으로 변환하고 시간 형식을 HH:mm으로 변환
    DateTime parsedTime = DateTime.parse(time); // time이 '2024-09-12 12:00:00.000' 형식이라고 가정
    String formattedTime = DateFormat('HH:mm').format(parsedTime); // 시간만 추출

    // 숫자에 따른 이모티콘 이미지 경로 설정
    String iconPath;
    if (scheduleIndex >= 1 && scheduleIndex <= 10) {
      iconPath = 'assets/icons/_$scheduleIndex.png'; // 1부터 10까지의 숫자 이모티콘
    } else {
      iconPath = 'assets/icons/_location.png'; // 디폴트 이미지
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // 외부 여백 설정
      padding: const EdgeInsets.all(8.0), // 내부 여백 설정
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!), // 테두리 색상 설정
        borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게
        color: Colors.white, // 배경색 흰색
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // 왼쪽 정렬
        children: [
          // 장소와 시간을 나란히 배치
          Row(
            children: [
              Image.asset(
                iconPath, // 이모티콘 이미지 경로
                width: 20, // 이미지 너비
                height: 20, // 이미지 높이
              ),
              SizedBox(width: 8.0), // 간격
              Text(
                place,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // 장소 표시
              ),
              SizedBox(width: 8.0), // 장소와 시간 사이 간격
              Text(
                formattedTime,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w100), // 시간 표시
              ),
            ],
          ),
          SizedBox(height: 8.0), // 장소와 메모 간격

          // 메모가 있을 경우 표시
          if (memo.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(memo, style: TextStyle(fontSize: 14)), // 메모 내용 표시
            ),

          // 교통편 및 메모 추가 버튼
          Row(
            children: [
              _buildWhiteButton('교통편 보기', () {}), // 교통편 보기 버튼
              SizedBox(width: 10), // 간격
              _buildWhiteButton('메모 추가', () async {
                // 메모 추가 버튼 클릭 시 스케줄 추가 뷰로 이동
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScheduleAddView(
                      travelId: widget.travelId, // travelId 전달
                      selectedDate: widget.startDate.add(Duration(days: _selectedDayIndex)), // 선택된 날짜 전달
                      travelViewModel: travelViewModel,  // ViewModel 인스턴스 전달
                      title: place,
                      startTime: time,
                      endTime: "23:59", // 기존 종료 시간 예시
                      memo: memo,
                    ),
                  ),
                );
                if (result == true) {
                  // 돌아온 후 화면 갱신
                  await travelViewModel.loadSchedules(widget.travelId).then((_) {
                    setState(() {
                      // 일정 업데이트
                    });
                  });
                }
              }),
            ],
          ),
        ],
      ),
    );
  }


  // 흰색 버튼 스타일을 설정하는 함수
  Widget _buildWhiteButton(String text, VoidCallback onPressed) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0), // 간격 설정
        child: TextButton(
          onPressed: onPressed, // 버튼 클릭 시 호출될 함수
          style: TextButton.styleFrom(
            backgroundColor: Colors.white, // 버튼 배경 흰색
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게
              side: BorderSide(color: Colors.grey[300]!), // 테두리 색상 설정
            ),
          ),
          child: Text(
            text, // 버튼 텍스트
            style: TextStyle(color: Colors.black), // 텍스트 색상
          ),
        ),
      ),
    );
  }

  // 일정 추가 버튼을 생성하는 함수
  Widget _buildAddScheduleButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // 패딩 설정
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
            icon: Icon(Icons.add), // 플러스 아이콘
            label: Text('일정 추가'), // 일정 추가 텍스트
          ),
        ],
      ),
    );
  }

  // AI 추천 섹션을 생성하는 함수
  Widget _buildAISuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // 패딩 설정
          child: Text('AI 추천', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // AI 추천 텍스트
        ),
        SizedBox(height: 10), // 간격
        Container(
          height: 150, // AI 추천 카드 높이 설정
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // 가로 스크롤 가능하도록 설정
            itemCount: 5, // 추천 카드 개수
            itemBuilder: (context, index) {
              return _buildAICard(index); // AI 추천 카드 생성 함수 호출
            },
          ),
        ),
      ],
    );
  }

  // AI 추천 카드를 생성하는 함수
  Widget _buildAICard(int index) {
    return Container(
      width: 150, // 카드 너비
      margin: EdgeInsets.only(right: 10), // 간격 설정
      decoration: BoxDecoration(
        color: Colors.grey[300], // 카드 배경색
        borderRadius: BorderRadius.circular(8), // 모서리 둥글게
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[400], // 이미지 배경색
              child: Center(child: Text('사진', style: TextStyle(fontSize: 16))), // 중앙에 사진 텍스트 표시
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0), // 패딩 설정
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
              children: [
                Text('장소명', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), // 장소명 텍스트
                SizedBox(height: 4), // 간격
                Text('별점: ★★★☆☆', style: TextStyle(fontSize: 12)), // 별점 텍스트
                SizedBox(height: 2), // 간격
                Text('거리: 1.2km', style: TextStyle(fontSize: 12)), // 거리 텍스트
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 좌우로 배치된 버튼을 만들기 위한 위젯 함수
  Widget _buildSaveAndAddButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), // 패딩 설정
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 좌우로 버튼 나누기
        children: [
          // '내 저장' 버튼 (주석 처리)
          /*
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  // '내 저장' 버튼 클릭 시 저장 장소 리스트가 표시되도록 상태 변경
                  _showSavedPlaces = !_showSavedPlaces; // 저장 장소 리스트의 표시 상태를 반전
                });
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Color(0xFFE8E8E8)),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white, // 버튼 배경색
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_outline, size: 12, color: Color(0xFF222222)), // 아이콘
                    const SizedBox(width: 4),
                    Text(
                      '내 저장', // 버튼 텍스트
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
          ),
          */
          // '일정 추가' 버튼 (전체 가로 차지)
          Expanded(
            child: GestureDetector(
              onTap: () async {
                // 일정 추가 페이지로 이동
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
                      // 일정 추가 후 UI 갱신
                    });
                  });
                }
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Color(0xFFE8E8E8)),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white, // 버튼 배경색
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 12, color: Color(0xFF222222)), // 플러스 아이콘
                    const SizedBox(width: 4),
                    Text(
                      '일정 추가', // 버튼 텍스트
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
          ),
        ],
      ),
    );
  }


// '내 저장 장소' 리스트를 보여주는 함수
  Widget _buildSavedPlaces() {
    return Visibility(
      visible: _showSavedPlaces, // _showSavedPlaces 값에 따라 가시성 변경
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // 패딩 설정
            child: Text('내 저장 장소', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // 저장 장소 제목
          ),
          SizedBox(height: 10), // 간격
          Container(
            height: 150, // 저장된 장소 카드 높이 설정
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // 가로 스크롤 가능하도록 설정
              itemCount: 5, // 저장된 장소 개수에 맞게 설정
              itemBuilder: (context, index) {
                return _buildSavedPlaceCard(index); // 저장된 장소 카드 생성
              },
            ),
          ),
        ],
      ),
    );
  }

// 저장된 장소 카드 구성하는 함수
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
}
