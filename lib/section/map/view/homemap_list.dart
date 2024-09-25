import 'package:flutter/material.dart'; // Flutter UI 라이브러리
import 'package:flutter_naver_map/flutter_naver_map.dart'; // 네이버 맵 플러그인
import 'dart:async'; // 비동기 처리에 필요한 라이브러리
import 'package:get/get.dart'; // 상태 관리를 위한 GetX 라이브러리
import 'package:project_island/section/map/viewmodel/homemap_list_controller.dart'; // ViewModel을 가져옴
import 'package:project_island/section/map/view/homemap_listview.dart'; // 리스트 뷰 위젯 가져옴
import 'package:project_island/section/map/widget/custom_appbar.dart'; // 커스텀 앱바 가져옴
import 'package:project_island/section/map/widget/upper_category_buttons.dart'; // 상위 카테고리 버튼 위젯 가져옴
import 'package:project_island/section/map/widget/lower_category_buttons.dart'; // 하위 카테고리 버튼 위젯 가져옴
import 'package:project_island/section/map/model/island_model.dart'; // 섬 모델 데이터 가져옴

// 메인 리스트 화면 클래스 정의
class HomemapList extends StatefulWidget {
  final String islandName; // 섬 이름을 받아옴
  const HomemapList({Key? key, required this.islandName}) : super(key: key);

  @override
  HomemapListState createState() => HomemapListState(); // 상태 객체 생성
}

// 상태 클래스 정의
class HomemapListState extends State<HomemapList> {
  final HomemapListController controller = Get.put(HomemapListController()); // GetX 컨트롤러 초기화
  final DraggableScrollableController draggableScrollableController = DraggableScrollableController(); // 바텀시트 컨트롤러
  final Completer<NaverMapController> _naverMapController = Completer(); // 네이버 맵 컨트롤러 비동기 초기화

  @override
  void initState() {
    super.initState();
    controller.resetCategories();  // 화면 로드 시 카테고리 초기화
    controller.onCategorySelected(widget.islandName); // 초기 카테고리 설정
    controller.loadInitialItems(widget.islandName); // 초기 데이터 로드

    // displayedItems 상태가 변경될 때마다 마커를 업데이트
    ever(controller.displayedItems, (_) {
      _addMarkersForItems(controller.displayedItems); // 마커 추가 함수 호출
    });
  }

  // 지도에 마커를 추가하는 함수
  void _addMarkersForItems(List<IslandModel> items) {
    _naverMapController.future.then((controller) {
      controller.clearOverlays(); // 기존 마커 삭제
      List<NMarker> markers = []; // 마커 리스트 생성

      for (var item in items) {
        final iconPath = _getIconPathForCategory(item.category); // 카테고리별 아이콘 경로 가져옴
        final marker = NMarker(
          id: '${item.latitude}-${item.longitude}', // 마커의 ID 설정 (위도, 경도)
          position: NLatLng(item.latitude, item.longitude), // 마커의 좌표 설정
          caption: NOverlayCaption(
            text: item.title, // 마커 제목 설정
            textSize: 15,
            color: Colors.black,
            haloColor: Colors.white,
          ),
          icon: NOverlayImage.fromAssetImage(iconPath), // 마커 아이콘 설정
          size: const Size(40, 40), // 마커 크기 설정
        );
        markers.add(marker); // 마커 리스트에 추가
      }

      controller.addOverlayAll(markers.toSet()); // 마커를 지도에 추가
    });
  }

  // 카테고리에 맞는 아이콘 경로를 반환하는 함수
  String _getIconPathForCategory(String category) {
    switch (category) {
      case '낚시': return 'assets/icons/_fishing.png';
      case '스쿠버 다이빙': return 'assets/icons/_diving.png';
      case '계곡': return 'assets/icons/_valley.png️';
      case '바다': return 'assets/icons/_beach.png';
      case '서핑': return 'assets/icons/_surfing.png';
      case '휴향림': return 'assets/icons/_forest.png';
      case '산책길': return 'assets/icons/_trail.png';
      case '역사': return 'assets/icons/_history.png';
      case '수상 레저': return 'assets/icons/_surfing.png';
      case '자전거': return 'assets/icons/_bicycle.png';
      case '한식': return 'assets/icons/_korea.png';
      case '양식': return 'assets/icons/_america.png';
      case '일식': return 'assets/icons/_japan.png';
      case '중식': return 'assets/icons/_china.png';
      case '분식': return 'assets/icons/_snacks.png';
      case '커피': return 'assets/icons/_coffee.png';
      case '베이커리': return 'assets/icons/_bakery.png';
      case '아이스크림/빙수': return 'assets/icons/_ice_cream.png';
      case '차': return 'assets/icons/_tea.png';
      case '과일/주스': return 'assets/icons/_juice.png';
      case '전통 디저트': return 'assets/icons/_dessert.png';
      case '모텔': return 'assets/icons/_house.png';
      case '호텔/리조트': return 'assets/icons/_house.png';
      case '캠핑': return 'assets/icons/_camping.png';
      case '게하/한옥': return 'assets/icons/_house.png';
      case '펜션': return 'assets/icons/_house.png';
      default: return 'assets/icons/shrimp.png'; // 기본 아이콘
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onSearchSubmitted: controller.onSearchSubmitted, // 검색 기능을 제공
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent, // 빈 공간 터치 인식
        onTap: () {
          FocusScope.of(context).unfocus(); // 키보드 닫기
        },
        child: Stack(
          children: [
            MapBackground(selectedIsland: widget.islandName), // 네이버 맵 배경 표시
            Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Obx(() => UpperCategoryButtons(
                    selectedCategory: controller.selectedCategory.value, // 선택된 상위 카테고리
                    onCategorySelected: controller.onCategorySelected, // 카테고리 선택 시 호출
                  )),
                ),
                Divider(color: Colors.grey[200], thickness: 1, height: 1), // 상위 카테고리 바와 하위 카테고리 바 사이의 구분선
                Expanded(
                  child: DraggableScrollableSheet(
                    controller: draggableScrollableController,
                    initialChildSize: controller.isFullScreen.value ? 1.0 : 0.3, // 초기 크기 설정
                    minChildSize: 0.3,
                    maxChildSize: 1.0,
                    expand: true,
                    builder: (BuildContext context, ScrollController scrollController) {
                      return BottomSheetContent(
                        controller: controller,
                        scrollController: scrollController,
                        draggableController: draggableScrollableController,
                        selectedSubCategory: controller.selectedSubCategory.value, // 선택된 하위 카테고리 전달
                        onSubCategorySelected: controller.onSubCategorySelected, // 하위 카테고리 선택 처리
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(
            () => controller.isFullScreen.value
            ? FloatingMapButton(
          onPressed: () {
            controller.isFullScreen.value = false; // 풀스크린 상태 해제
            draggableScrollableController.animateTo(
              0.4,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut, // 애니메이션
            );
          },
        )
            : const SizedBox.shrink(), // 빈 공간을 표시하여 버튼 숨김
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // 플로팅 액션 버튼 위치
    );
  }
}

// 네이버 맵 배경을 표시하는 위젯
class MapBackground extends StatelessWidget {
  final String selectedIsland; // 선택된 섬 이름

  const MapBackground({Key? key, required this.selectedIsland}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NLatLng initialPosition; // 초기 지도 위치
    double initialZoom; // 초기 줌 레벨

    // 섬 이름에 따른 초기 위치 설정
    switch (selectedIsland) {
      case '덕적도':
        initialPosition = NLatLng(37.2138, 126.1344);
        initialZoom = 11.4;
        break;
      case '거제도':
        initialPosition = NLatLng(34.7706, 128.6217);
        initialZoom = 9.27;
        break;
      case '울릉도':
        initialPosition = NLatLng(37.4706, 130.8655);
        initialZoom = 10.75;
        break;
      case '안면도':
        initialPosition = NLatLng(36.4162, 126.3867);
        initialZoom = 9.4;
        break;
      case '진도':
        initialPosition = NLatLng(34.3987, 126.2530);
        initialZoom = 9.7;
        break;
      default:
        initialPosition = NLatLng(36.0665, 127.2780); // 기본 위치는 서울
        initialZoom = 5.8;
        break;
    }

    return Positioned.fill(
      child: NaverMap(
        onMapReady: (controller) {
          final HomemapListState? parentState = context.findAncestorStateOfType<HomemapListState>();
          if (parentState != null) {
            parentState._naverMapController.complete(controller); // 맵 컨트롤러 완료 처리
          }
        },
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
            target: initialPosition, // 초기 카메라 위치 설정
            zoom: initialZoom, // 초기 줌 설정
          ),
        ),
      ),
    );
  }
}
// 바텀시트 내용을 정의하는 클래스
class BottomSheetContent extends StatelessWidget {
  // HomemapListController: 지도 데이터 및 상태를 관리하는 컨트롤러
  final HomemapListController controller;
  // ScrollController: 리스트 스크롤을 제어하는 컨트롤러
  final ScrollController scrollController;
  // DraggableScrollableController: 바텀시트 확장 및 축소를 제어하는 컨트롤러
  final DraggableScrollableController draggableController;
  // 선택된 하위 카테고리 (string 형식으로 전달됨)
  final String selectedSubCategory;
  // 하위 카테고리 선택 콜백 함수, 선택된 하위 카테고리를 처리
  final ValueChanged<String> onSubCategorySelected;

  // 생성자: 이 클래스는 필요한 컨트롤러와 상태 값을 파라미터로 받음
  const BottomSheetContent({
    Key? key,
    required this.controller,
    required this.scrollController,
    required this.draggableController,
    required this.selectedSubCategory,
    required this.onSubCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // NotificationListener: 바텀시트의 확장/축소 이벤트를 감지하여 상태를 업데이트
    return NotificationListener<DraggableScrollableNotification>(
      // onNotification: 바텀시트 확장 상태 감지 및 처리
      onNotification: (notification) {
        // 바텀시트가 완전히 확장된 상태(1.0)일 때 풀스크린 상태로 설정
        if (notification.extent == 1.0 && !controller.isFullScreen.value) {
          controller.isFullScreen.value = true;
        }
        // 바텀시트가 완전히 확장되지 않은 경우 풀스크린 상태 해제
        else if (notification.extent < 1.0 && controller.isFullScreen.value) {
          controller.isFullScreen.value = false;
        }
        return true; // 이벤트 처리 완료
      },
      // Obx: GetX 상태 관리에 따른 UI 업데이트, 상태 변경을 감지하여 UI를 동적으로 렌더링
      child: Obx(
            () => Container(
          // Container의 배경 및 모서리 둥글기 설정
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: controller.isFullScreen.value
                ? BorderRadius.zero // 풀스크린 상태에서는 모서리 둥글기 없음
                : const BorderRadius.vertical(top: Radius.circular(20)), // 풀스크린이 아닌 경우 위쪽 모서리 둥글게 설정
          ),
          child: Column(
            children: [
              // 풀스크린 상태가 아닐 때만 상단 핸들 표시
              if (!controller.isFullScreen.value)
                Container(
                  width: 40, // 핸들의 너비
                  height: 4, // 핸들의 높이
                  margin: const EdgeInsets.symmetric(vertical: 5), // 위아래 여백
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // 핸들의 색상
                    borderRadius: BorderRadius.circular(10), // 핸들의 모서리 둥글기 설정
                  ),
                ),
              // 상위 카테고리가 선택된 경우 하위 카테고리 버튼 표시
              if (controller.selectedCategory.isNotEmpty)
                LowerCategoryButtons(
                  selectedSubCategory: controller.selectedSubCategory.value, // 선택된 하위 카테고리 전달
                  onSubCategorySelected: controller.onSubCategorySelected, // 하위 카테고리 선택 시 콜백 함수 호출
                  subCategories: controller.subCategories, // 하위 카테고리 목록 전달
                  selectedCategory: controller.selectedCategory.value, // 상위 카테고리 전달
                  // '전체' 버튼이 눌렸을 때 처리할 로직
                  onAllSelected: () {
                    controller.onSubCategorySelected('전체'); // '전체' 선택 시 처리
                  },
                ),
              // '목록' 텍스트와 현재 표시된 항목 개수를 표시하는 위젯
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 10), // 좌우 및 상단/하단 여백
                child: Align(
                  alignment: Alignment.centerLeft, // 텍스트를 왼쪽 정렬
                  child: Row(
                    children: [
                      const Text(
                        '목록 ', // '목록' 텍스트
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold), // 텍스트 스타일
                      ),
                      Text(
                        '${controller.displayedItems.length}개', // 표시된 항목 개수를 동적으로 표시
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold), // 항목 개수 텍스트 스타일
                      ),
                    ],
                  ),
                ),
              ),
              // 목록을 표시할 수 있는 확장 가능한 영역
              Expanded(
                child: Stack(
                  children: [
                    // 표시된 항목이 없을 경우 '검색 결과가 없어요' 메시지 출력
                    controller.displayedItems.isEmpty
                        ? const Center(child: Text('검색 결과가 없어요 😥'))
                        : HomemapListView(
                      items: controller.displayedItems, // 표시할 항목 전달
                      controller: controller, // 리스트 뷰에 사용될 컨트롤러 전달
                      scrollController: scrollController, // 스크롤 컨트롤러 전달
                    ),
                    // 로딩 상태일 때 로딩 스피너 표시
                    if (controller.isLoading.value)
                      IgnorePointer( // 터치 이벤트를 무시하기 위해 추가
                        ignoring: true, // 로딩 중 스크롤 및 터치 무시
                        child: Container(
                          color: Colors.white.withOpacity(0.7), // 로딩 중 화면을 흐리게 처리
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.green[300], // 로딩 인디케이터 색상
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// '지도 보기' 버튼 위젯 정의
class FloatingMapButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingMapButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.pin_drop_sharp, color: Colors.white, size: 18), // 핀 드롭 아이콘
                SizedBox(width: 8), // 아이콘과 텍스트 간의 간격
                Text('지도보기', style: TextStyle(color: Colors.white, fontSize: 18)), // 텍스트
              ],
            ),
          ),
        ),
      ),
    );
  }
}
