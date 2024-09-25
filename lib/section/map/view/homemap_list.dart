import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:project_island/section/map/viewmodel/homemap_list_controller.dart';
import 'package:project_island/section/map/view/homemap_listview.dart';
import 'package:project_island/section/map/widget/custom_appbar.dart';
import 'package:project_island/section/map/widget/upper_category_buttons.dart';
import 'package:project_island/section/map/widget/lower_category_buttons.dart'; // 하위 카테고리 버튼 위젯 import
import 'package:project_island/section/map/model/island_model.dart';
import 'package:url_launcher/url_launcher.dart';


// 메인 리스트 화면 클래스
class HomemapList extends StatefulWidget {
  final String islandName; // 섬 이름을 받아옴
  const HomemapList({Key? key, required this.islandName}) : super(key: key);

  @override
  HomemapListState createState() => HomemapListState();
}

class HomemapListState extends State<HomemapList> with WidgetsBindingObserver {
  // 컨트롤러 초기화 (GetX 사용)
  final HomemapListController controller = Get.put(HomemapListController());
  final DraggableScrollableController draggableScrollableController = DraggableScrollableController(); // 바텀시트 컨트롤러
  final Completer<NaverMapController> _naverMapController = Completer(); // 네이버 맵 컨트롤러

  bool _isKeyboardOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observer 추가
    controller.resetCategories();  // 화면이 로드될 때 카테고리 초기화
    controller.onCategorySelected(widget.islandName); // 초기 카테고리 설정
    controller.loadInitialItems(widget.islandName); // 초기 데이터 로드

    // displayedItems 상태가 변경될 때마다 마커를 업데이트하는 로직
    ever(controller.displayedItems, (_) {
      _addMarkersForItems(controller.displayedItems);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Observer 제거
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newIsKeyboardOpen = bottomInset > 0.0;
    if (newIsKeyboardOpen != _isKeyboardOpen) {
      _isKeyboardOpen = newIsKeyboardOpen;
      if (_isKeyboardOpen) {
        // 키보드가 열릴 때 바텀 시트를 전체 화면으로 확장
        draggableScrollableController.animateTo(
          1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // 키보드가 닫힐 때 바텀 시트를 원래 크기로 복원
        draggableScrollableController.animateTo(
          0.35,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _addMarkersForItems(List<IslandModel> items) {
    _naverMapController.future.then((controller) {
      // 기존 마커를 모두 삭제
      controller.clearOverlays();

      List<NMarker> markers = [];

      for (var item in items) {
        final iconPath = _getIconPathForCategory(item.category); // 카테고리에 맞는 아이콘 경로 가져오기

        final marker = NMarker(
          id: '${item.latitude}-${item.longitude}', // 위도와 경도를 조합해 id 생성
          position: NLatLng(item.latitude, item.longitude), // 아이템의 위도와 경도
          caption: NOverlayCaption(
            text: item.title, // 마커에 표시될 제목
            textSize: 15,
            color: Colors.black,
            haloColor: Colors.white,
          ),
          icon: NOverlayImage.fromAssetImage(iconPath),
          size: const Size(40, 40),
        );

        // 마커 클릭 시 이벤트 처리
        marker.setOnTapListener((overlay) {
          setState(() async {
            String url = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(item.name)}&query_place_id=${item.placeId}';
            Uri uri = Uri.parse(url);
            if (await canLaunch(uri.toString())) {
              await launch(uri.toString(), forceSafariVC: false, forceWebView: false);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('해당 장소의 정보를 열 수 없습니다.')),
              );
            }
          });
        });

        markers.add(marker);
      }

      // 새로운 마커 추가
      controller.addOverlayAll(markers.toSet());
    });
  }

  String _getIconPathForCategory(String category) {
    switch (category) {
      case '낚시':
        return 'assets/icons/_fishing.png';
      case '스쿠버 다이빙':
        return 'assets/icons/_diving.png';
      case '계곡':
        return 'assets/icons/_valley.png️';
      case '바다':
        return 'assets/icons/_beach.png';
      case '산/휴향림':
        return 'assets/icons/_mountain.png';
      case '산책길':
        return 'assets/icons/_trail.png';
      case '역사':
        return 'assets/icons/_history.png';
      case '수상 레저':
        return 'assets/icons/_surfing.png';
      case '자전거':
        return 'assets/icons/_bicycle.png';
      case '한식':
        return 'assets/icons/_korea.png';
      case '양식':
        return 'assets/icons/_america.png';
      case '일식':
        return 'assets/icons/_japan.png';
      case '중식':
        return 'assets/icons/_china.png';
      case '분식':
        return 'assets/icons/_snacks.png';
      case '커피':
        return 'assets/icons/_coffee.png';
      case '베이커리':
        return 'assets/icons/_bakery.png';
      case '아이스크림/빙수':
        return 'assets/icons/_shaved-ice.png';
      case '차':
        return 'assets/icons/_tea.png';
      case '과일/주스':
        return 'assets/icons/_juice.png';
      case '모텔':
        return 'assets/icons/_motel.png';
      case '호텔/리조트':
        return 'assets/icons/_hotel.png';
      case '캠핑':
        return 'assets/icons/_camping.png';
      case '게하/한옥':
        return 'assets/icons/_house.png';
      case '펜션':
        return 'assets/icons/_house.png';
      default:
        return 'assets/icons/3disland.png'; // 기본 이모지
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 키보드가 올라왔을 때 화면 크기 조정
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
                // 상위 카테고리 버튼을 포함한 컨테이너
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
                    initialChildSize: controller.isFullScreen.value ? 1.0 : 0.35,
                    minChildSize: 0.35,
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
            ? SafeArea(
          child: FloatingMapButton(
            onPressed: () {
              FocusScope.of(context).unfocus(); // 키보드 닫기
              controller.isFullScreen.value = false; // 풀스크린 상태 해제
              draggableScrollableController.animateTo(
                0.35,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
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
    // 키보드가 나타날 때의 패딩을 계산
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

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
            () => SafeArea(
          bottom: false, // 바텀 시트 내에서만 SafeArea를 적용
          child: Padding(
            padding: EdgeInsets.only(bottom: keyboardHeight), // 키보드 높이만큼 패딩 추가
            child: Container(
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
                  // 하위 카테고리 바: 시트 내에 배치
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
                            ? const Center(child: Text('검색 결과가 없습니다'))
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
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.green,
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