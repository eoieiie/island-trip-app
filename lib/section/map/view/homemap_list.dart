import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:project_island/section/map/viewmodel/homemap_list_controller.dart';
import 'package:project_island/section/map/view/homemap_listview.dart';
import 'package:project_island/section/map/widget/custom_appbar.dart';
import 'package:project_island/section/map/widget/upper_category_buttons.dart';
import 'package:project_island/section/map/widget/lower_category_buttons.dart'; // 하위 카테고리 버튼 위젯 import

// 메인 리스트 화면 클래스
class HomemapList extends StatefulWidget {
  final String islandName; // 섬 이름을 받아옴
  const HomemapList({Key? key, required this.islandName}) : super(key: key);

  @override
  HomemapListState createState() => HomemapListState();
}

class HomemapListState extends State<HomemapList> {
  // 컨트롤러 초기화 (GetX 사용)
  final HomemapListController controller = Get.put(HomemapListController());
  final DraggableScrollableController draggableScrollableController = DraggableScrollableController(); // 바텀시트 컨트롤러
  final Completer<NaverMapController> _naverMapController = Completer(); // 네이버 맵 컨트롤러

  @override
  void initState() {
    super.initState();
    controller.resetCategories();  // 화면이 로드될 때 카테고리 초기화
    controller.onCategorySelected(widget.islandName); // 초기 카테고리 설정
    controller.loadInitialItems(widget.islandName); // 초기 데이터 로드
  }

  // 특정 좌표에 마커를 추가하는 함수
  void _addMarker(double lat, double lng, String markerId) {
    _naverMapController.future.then((controller) {
      final marker = NMarker(
        id: markerId,
        position: NLatLng(lat, lng), // 마커 위치
        caption: NOverlayCaption(
          text: "Marker: $markerId", // 마커 ID 표시
          textSize: 1,
          color: Colors.black,
          haloColor: Colors.white,
        ),
        icon: NOverlayImage.fromAssetImage('assets/marker_icon.png'), // 마커 아이콘 설정
        size: const Size(40, 40),
      );
      controller.addOverlay(marker); // 맵에 마커 추가
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 검색 기능을 포함한 커스텀 앱바
      appBar: CustomAppBar(
        onSearchSubmitted: controller.onSearchSubmitted, // 검색어 제출 시 처리
      ),
      backgroundColor: Colors.white,
      // body를 GestureDetector로 감싸서 빈 공간 터치 시 키보드를 해제합니다.
      body: GestureDetector(
        behavior: HitTestBehavior.translucent, // 투명한 영역도 터치 이벤트 감지
        onTap: () {
          FocusScope.of(context).unfocus(); // 키보드 해제
        },
        child: Stack(
          children: [
            // 네이버 맵을 배경에 표시
            MapBackground(selectedIsland: widget.islandName),
            Column(
              children: [
                // 상위 카테고리 버튼과 하위 카테고리 버튼을 포함한 컨테이너
                Container(
                  color: Colors.white, // 상위 카테고리 바의 배경색을 흰색으로 설정
                  child: Obx(() => UpperCategoryButtons(
                    selectedCategory: controller.selectedCategory.value,
                    onCategorySelected: controller.onCategorySelected,
                  )),
                ),
                // 상위 카테고리와 하위 카테고리 사이 경계선
                Divider(color: Colors.grey[200], thickness: 1, height: 1),
                Expanded(
                  // 바텀시트: 스크롤 시 확장/축소 가능한 시트
                  child: DraggableScrollableSheet(
                    controller: draggableScrollableController,
                    initialChildSize: controller.isFullScreen.value ? 1.0 : 0.25,
                    minChildSize: 0.25,
                    maxChildSize: 1.0,
                    expand: true,
                    builder: (BuildContext context, ScrollController scrollController) {
                      return BottomSheetContent(
                        controller: controller,
                        scrollController: scrollController,
                        draggableController: draggableScrollableController,
                        selectedSubCategory: controller.selectedSubCategory.value, // 하위 카테고리 전달
                        onSubCategorySelected: controller.onSubCategorySelected, // 하위 카테고리 선택 로직 전달
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // 지도 보기 버튼
      floatingActionButton: Obx(
            () => controller.isFullScreen.value
            ? FloatingMapButton(
          onPressed: () {
            controller.isFullScreen.value = false; // 풀스크린 상태 해제
            draggableScrollableController.animateTo(
              0.4,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        )
            : const SizedBox.shrink(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// 네이버 맵을 배경에 표시하는 위젯
class MapBackground extends StatelessWidget {
  final String selectedIsland; // 선택된 섬

  const MapBackground({Key? key, required this.selectedIsland}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 초기 좌표와 줌 레벨 설정
    NLatLng initialPosition;
    double initialZoom;

    // 선택된 섬에 따라 위치 및 줌 레벨 설정
    switch (selectedIsland) {
      case '덕적도':
        initialPosition = NLatLng(37.2138, 126.1344); // 덕적도 좌표
        initialZoom = 11.4;
        break;
      case '거제도':
        initialPosition = NLatLng(34.7706, 128.6217); // 거제도 좌표
        initialZoom = 9.27;
        break;
      case '울릉도':
        initialPosition = NLatLng(37.4706, 130.8655); // 울릉도 좌표
        initialZoom = 10.75;
        break;
      case '안면도':
        initialPosition = NLatLng(36.4162, 126.3867); // 안면도 좌표
        initialZoom = 9.4;
        break;
      case '진도':
        initialPosition = NLatLng(34.3987, 126.2530); // 진도 좌표
        initialZoom = 9.7;
        break;
      default:
        initialPosition = NLatLng(36.0665, 127.2780); // 기본 위치 (서울)
        initialZoom = 5.8;
        break;
    }

    return Positioned.fill(
      // 네이버 맵 설정
      child: NaverMap(
        onMapReady: (controller) {
          final HomemapListState? parentState = context.findAncestorStateOfType<HomemapListState>();
          if (parentState != null) {
            parentState._naverMapController.complete(controller); // 네이버 맵 컨트롤러 설정
          }
        },
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
            target: initialPosition, // 선택된 섬의 초기 위치
            zoom: initialZoom,       // 선택된 섬의 줌 레벨
          ),
        ),
      ),
    );
  }
}


class BottomSheetContent extends StatelessWidget {
  final HomemapListController controller;
  final ScrollController scrollController;
  final DraggableScrollableController draggableController;
  final String selectedSubCategory;
  final ValueChanged<String> onSubCategorySelected;

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
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent == 1.0 && !controller.isFullScreen.value) {
          controller.isFullScreen.value = true;
        } else if (notification.extent < 1.0 && controller.isFullScreen.value) {
          controller.isFullScreen.value = false;
        }
        return true;
      },
      child: Obx(
            () => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: controller.isFullScreen.value
                ? BorderRadius.zero
                : const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              if (!controller.isFullScreen.value)
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              // 상위 카테고리가 선택된 경우에만 하위 카테고리 바를 표시합니다.
              if (controller.selectedCategory.isNotEmpty)
                LowerCategoryButtons(
                  selectedSubCategory: controller.selectedSubCategory.value, // 선택된 하위 카테고리
                  onSubCategorySelected: controller.onSubCategorySelected, // 하위 카테고리 선택 시 호출
                  subCategories: controller.subCategories, // 동적으로 하위 카테고리 목록을 표시
                  selectedCategory: controller.selectedCategory.value, // 추가된 파라미터
                  onAllSelected: () { // '전체' 버튼을 눌렀을 때 실행할 콜백 함수
                    controller.onSubCategorySelected('전체'); // '전체' 카테고리를 처리하는 로직
                  },
                ),

              Divider(color: Colors.grey[200], thickness: 1, height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Text(
                        '목록 ',
                        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${controller.displayedItems.length}개',
                        style: const TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    controller.displayedItems.isEmpty
                        ? const Center(child: Text('저장된 항목이 없습니다.'))
                        : HomemapListView(
                      items: controller.displayedItems,
                      controller: controller,
                      scrollController: scrollController,
                    ),
                    if (controller.isLoading.value)
                      IgnorePointer( // 스크롤 가능하게 하기 위해 추가
                        ignoring: true,
                        child: Container(
                          color: Colors.white.withOpacity(0.7),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.green[300],
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

// '지도보기' 버튼을 표시하는 위젯
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
                Icon(Icons.pin_drop_sharp, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('지도보기', style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}