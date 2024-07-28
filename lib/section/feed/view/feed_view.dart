import 'dart:math'; // Random 클래스를 사용하기 위해 math 패키지 가져오기
import 'dart:async';
import 'package:flutter/material.dart'; // Flutter UI 구성 요소 패키지
import 'package:project_island/section/feed/view/review_write_view.dart'; // ReviewWriteView 파일 가져오기
import 'package:project_island/section/feed/view/search_focus_view.dart'; // SearchFocus 파일 가져오기
import 'package:project_island/section/feed/view/photo_detail_view.dart'; // PhotoDetailView 파일 가져오기
import 'package:flutter_naver_map/flutter_naver_map.dart'; // Naver 지도 패키지

class FeedView extends StatefulWidget { // FeedView라는 Stateful 위젯 선언
  const FeedView({Key? key}) : super(key: key); // 생성자

  @override
  State<FeedView> createState() => _FeedViewState(); // 상태 객체 생성
}

// _FeedViewState 클래스, 상태 관리를 담당
class _FeedViewState extends State<FeedView> { // FeedView의 상태 클래스
  List<List<int>> groupBox = [[], [], []]; // 3개의 빈 리스트로 이루어진 groupBox 리스트 생성
  List<int> groupIndex = [0, 0, 0]; // 3개의 0으로 초기화된 groupIndex 리스트 생성
  final Completer<NaverMapController> _controller = Completer();
  late Future<void> _initialization; //기존, 위는 추가한거임

  @override
  void initState() { // 상태 초기화 메서드
    super.initState();
    _initialization = _initializeNaverMap(); // 네이버 지도 초기화

    if (groupIndex.isNotEmpty) { // groupIndex가 비어있지 않으면
      for (var i = 0; i < 100; i++) { // 100번 반복
        var minIndex = groupIndex.indexOf(groupIndex.reduce((value, element) => value < element ? value : element)); // 가장 작은 값을 가진 인덱스 찾기
        var size = 1; // 기본 크기 1로 설정
        if (minIndex != 1) { // 인덱스가 1이 아니면
          size = Random().nextInt(100) % 2 == 0 ? 1 : 2; // 랜덤으로 1 또는 2 할당
        }
        groupBox[minIndex].add(size); // 해당 인덱스에 크기 추가
        groupIndex[minIndex] += size; // 해당 인덱스 크기 업데이트
      }
    }
  }

  // 네이버 지도 초기화 함수
  Future<void> _initializeNaverMap() async {
    WidgetsFlutterBinding.ensureInitialized();
    await NaverMapSdk.instance.initialize(
      clientId: 'tvzws5acgu', // API 키
      onAuthFailed: (e) {
        print('네이버맵 인증오류: $e');
      },
    );
  }

  // 네이버 지도 준비 완료 시 호출되는 함수
  void _onMapReady(NaverMapController controller) {
    _controller.complete(controller);

    // 마커 생성
    final marker1 = NMarker(
      id: '1',
      position: const NLatLng(37.5665, 126.9780), // 서울 위치
    );
    final marker2 = NMarker(
      id: '2',
      position: const NLatLng(37.5765, 126.9880), // 서울 다른 위치
    );

    controller.addOverlayAll({marker1, marker2}); // 마커 지도에 추가
  }

  @override
  Widget build(BuildContext context) { // 빌드 메서드
    return DefaultTabController(
      length: 2, // 탭의 개수
      child: Scaffold(
        appBar: AppBar(
          elevation: 0, // 그림자 제거
          title: _appbar(), // _appbar 위젯을 title로 사용
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.feed_rounded)), // 첫 번째 탭 아이콘
              Tab(icon: Icon(Icons.map)), // 두 번째 탭 아이콘
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _body(), // 첫 번째 탭 내용
            _mapView(context), // 두 번째 탭 내용
          ],
        ),
      ),
    );
  }

  Widget _appbar() { // 커스텀 앱바 위젯
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SearchFocus())); // SearchFocus 화면으로 이동
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10), // 패딩 설정
              margin: const EdgeInsets.only(left: 15), // 왼쪽 여백 설정
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6), // 모서리를 둥글게 설정
                color: const Color(0xffefefef), // 배경색 설정
              ),
              child: const Row(
                children: [
                  Icon(Icons.search), // 검색 아이콘
                  Text(
                    '검색', // 검색창 텍스트
                    style: TextStyle(
                      fontSize: 15, // 텍스트 크기
                      color: Color(0xff838383), // 텍스트 색상
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit), // 수정 아이콘
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewWriteView())); // ReviewWriteView로 이동
          },
        ),
      ],
    );
  }

  Widget _body() { // 피드 내용 위젯
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // 시작 위치에서 정렬
        children: List.generate( // 3개의 그룹 생성
          groupBox.length,
              (index) => Expanded(
            child: Column(
              children: List.generate(
                groupBox[index].length,
                    (jndex) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoDetailView(
                          // 여기에서 PhotoDetailView로 전달할 인자 설정
                          // 예를 들어, 이미지 URL 또는 ID를 전달할 수 있습니다.
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.33 * groupBox[index][jndex], // 크기 설정. Get.width를 MediaQuery.of(context).size.width로 바꿨더니 간결성은 떨어지지만 오류가 사라졌다ㅠㅠㅠ
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white), // 경계선 설정
                      color: Colors.primaries[
                      Random().nextInt(Colors.primaries.length)], // 랜덤 색상 설정
                    ),
                  ),
                ),
              ).toList(),
            ),
          ),
        ).toList(),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4, // 초기 크기 설정
      minChildSize: 0.2, // 최소 크기 설정
      maxChildSize: 0.8, // 최대 크기 설정
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: Colors.white, // 배경 색상 설정
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragUpdate: (details) {
                  // 스크롤 컨트롤러를 사용하여 드래그 동작을 업데이트
                  scrollController.position.moveTo(scrollController.position.pixels - details.primaryDelta!);
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
                      SizedBox(height: 10), // 간격 추가
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 20, // 예제용 아이템 수
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text('Item $index'), // 아이템 텍스트 설정
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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

  Widget _mapView(BuildContext context) { // 지도 화면 위젯
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(), // 네이버 지도 위젯
          Expanded(child: _buildBottomSheet(context)), // 바텀 시트 위젯
        ],
      ),
    );
  }
}
