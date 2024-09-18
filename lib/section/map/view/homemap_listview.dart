import 'package:flutter/material.dart';
import 'package:project_island/section/map/viewmodel/homemap_list_controller.dart';
import 'package:project_island/section/map/widget/custom_appbar.dart';
import 'package:project_island/section/map/widget/category_buttons.dart';
import 'package:project_island/section/map/model/island_model.dart';
import 'package:project_island/section/map/view/homemap_listview.dart';

class HomemapList extends StatefulWidget {
  const HomemapList({super.key});

  @override
  HomemapListState createState() => HomemapListState();
}

class HomemapListState extends State<HomemapList> {
  final HomemapListController controller = HomemapListController();
  String selectedCategory = '관심';
  String selectedSubCategory = '';
  bool isFullScreen = false; // Fullscreen 여부
  bool isMapView = false; // 지도 보기 상태 관리
  final double minSheetHeight = 0.4; // 바텀 시트 최소 높이
  final double fullScreenSheetHeight = 1.0; // 바텀 시트 전체 화면 높이
  final double triggerExtent = 0.75; // 자동으로 fullscreen으로 전환되는 기준 높이

  // ScrollController를 정의하여 수동으로 스크롤 위치를 설정할 수 있게 함
  ScrollController? sheetScrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // 상단 앱바
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 지도는 항상 배경에 깔려 있음
          Positioned.fill(
            child: Container(
              color: Colors.blueGrey, // 네이버 지도 위치 (현재는 임시 색상)
              child: const Center(child: Text('네이버 맵', style: TextStyle(color: Colors.white))),
            ),
          ),
          Column(
            children: [
              // 상위 카테고리 바는 고정된 위치에 있음, 흰색 배경 설정
              Container(
                color: Colors.white, // 배경색을 흰색으로 설정
                child: CategoryButtons(
                  selectedCategory: selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      selectedCategory = category;
                      selectedSubCategory = '';
                    });
                  },
                ),
              ),
              // DraggableScrollableSheet 부분
              if (isMapView) // 지도 보기 버튼을 누르면 바텀시트가 나타남
                Expanded(
                  child: DraggableScrollableSheet(
                    initialChildSize: isFullScreen ? fullScreenSheetHeight : minSheetHeight, // 초기 높이 설정
                    minChildSize: minSheetHeight, // 최소 높이
                    maxChildSize: fullScreenSheetHeight, // 최대 높이
                    expand: true, // Fullscreen 모드 시 전체 화면으로 확장
                    builder: (BuildContext context, ScrollController scrollController) {
                      sheetScrollController = scrollController; // ScrollController 저장

                      return NotificationListener<DraggableScrollableNotification>(
                        onNotification: (notification) {
                          // 스크롤 중간에 기준점(0.75)을 넘으면 자동으로 fullscreen 전환
                          if (notification.extent >= triggerExtent && !isFullScreen) {
                            setState(() {
                              isFullScreen = true; // Fullscreen 상태로 전환
                            });
                            // ScrollController를 사용하여 자동으로 최상단까지 부드럽게 스크롤
                            sheetScrollController!.animateTo(
                              sheetScrollController!.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300), // 부드러운 애니메이션
                              curve: Curves.easeInOut,
                            );
                          } else if (notification.extent < triggerExtent && isFullScreen) {
                            // 기준점 아래로 내려가면 다시 minSheetHeight로 되돌림
                            setState(() {
                              isFullScreen = false; // Fullscreen 해제
                            });
                          }
                          return true;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: isFullScreen
                                ? BorderRadius.zero // Fullscreen일 때 모서리 둥글기 제거
                                : BorderRadius.vertical(top: Radius.circular(20)), // 바텀시트일 때 둥근 모서리
                          ),
                          child: Column(
                            children: [
                              // 바텀 시트 상태일 때 손잡이 바 표시
                              if (!isFullScreen)
                                Container(
                                  width: 40,
                                  height: 6,
                                  margin: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              // 하위 카테고리 바
                              if (selectedCategory == '관심') ...[
                                Divider(color: Colors.grey[200], thickness: 1, height: 0),
                                SubCategoryButtons(
                                  selectedSubCategory: selectedSubCategory,
                                  onSubCategorySelected: (subCategory) {
                                    setState(() {
                                      selectedSubCategory = subCategory;
                                    });
                                  },
                                ),
                              ],
                              Divider(color: Colors.grey[200], thickness: 1, height: 5),
                              // 목록 개수 표시
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
                                      _buildItemCountText(),
                                    ],
                                  ),
                                ),
                              ),
                              // HomemapListView 사용하여 장소 정보 표시
                              Expanded(
                                child: FutureBuilder<List<IslandModel>>(
                                  future: controller.getItemsByCategory(
                                      selectedSubCategory.isEmpty ? selectedCategory : selectedSubCategory),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(child: Text('오류 발생: ${snapshot.error}'));
                                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                      return const Center(child: Text('저장된 항목이 없습니다.'));
                                    } else {
                                      final items = snapshot.data!;
                                      // HomemapListView에서 ScrollController 전달
                                      return HomemapListView(
                                        items: items,
                                        controller: controller,
                                        scrollController: sheetScrollController!, // ScrollController 전달
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
      // 처음 '지도 보기' 버튼 표시, 이 버튼을 누르면 바텀시트가 나타남
      floatingActionButton: isFullScreen // Fullscreen 상태에서만 '지도 보기' 버튼 표시
          ? Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: GestureDetector(
            onTap: () {
              // '지도 보기' 버튼을 누르면 바텀 시트가 0.4 높이로 줄어듬
              setState(() {
                isFullScreen = false; // Fullscreen 상태 해제
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pin_drop_sharp, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  const Text('지도보기', style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
          ),
        ),
      )
          : (!isMapView // 지도 보기 버튼은 처음에는 보이고, 바텀시트가 나타나면 숨김
          ? Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: GestureDetector(
            onTap: () {
              // '지도 보기' 버튼을 누르면 목록이 바텀시트로 나타남
              setState(() {
                isMapView = true; // 지도 보기 상태로 전환
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pin_drop_sharp, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  const Text('지도보기', style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
          ),
        ),
      )
          : null), // 지도 보기 버튼은 바텀시트가 있을 때는 숨김
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // 목록 개수 표시를 위한 메서드
  Widget _buildItemCountText() {
    return FutureBuilder<List<IslandModel>>(
      future: controller.getItemsByCategory(selectedSubCategory.isEmpty ? selectedCategory : selectedSubCategory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(
            '불러오는 중...',
            style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
          );
        } else if (snapshot.hasError) {
          return const Text(
            '오류 발생',
            style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text(
            '0개',
            style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
          );
        } else {
          return Text(
            '${snapshot.data!.length}개',
            style: const TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
          );
        }
      },
    );
  }
}
