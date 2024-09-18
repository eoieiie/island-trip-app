import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_island/section/map/viewmodel/homemap_list_controller.dart';
import 'package:project_island/section/map/view/homemap_listview.dart';
import 'package:project_island/section/map/widget/custom_appbar.dart';
import 'package:project_island/section/map/widget/category_buttons.dart';


class HomemapList extends StatefulWidget {
  final String islandName;

  const HomemapList({Key? key, required this.islandName}) : super(key: key);

  @override
  HomemapListState createState() => HomemapListState();
}

class HomemapListState extends State<HomemapList> {
  final HomemapListController controller = Get.put(HomemapListController());
  // DraggableScrollableController를 선언하여 바텀시트의 높이를 제어합니다.
  final DraggableScrollableController draggableScrollableController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    // 초기 카테고리를 설정하고 데이터를 로드합니다.
    controller.onCategorySelected(widget.islandName);
    controller.loadInitialItems(widget.islandName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 검색 기능이 있는 커스텀 앱바를 사용합니다.
      appBar: CustomAppBar(
        onSearchSubmitted: controller.onSearchSubmitted, // ViewModel에서 처리
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 네이버 맵을 배경에 표시합니다.
          Positioned.fill(
            child: Container(
              color: Colors.blueGrey,
              child: const Center(child: Text('네이버 맵', style: TextStyle(color: Colors.white))),
            ),
          ),
          // 바텀시트와 카테고리 버튼 등을 포함하는 컬럼 위젯입니다.
          Column(
            children: [
              // 카테고리 버튼들을 표시합니다.
              Container(
                color: Colors.white,
                child: Obx(() => CategoryButtons(
                  selectedCategory: controller.selectedCategory.value,
                  onCategorySelected: controller.onCategorySelected, // ViewModel에서 처리
                )),
              ),
              // DraggableScrollableSheet를 사용하여 바텀시트를 구현합니다.
              Expanded(
                child: DraggableScrollableSheet(
                  controller: draggableScrollableController, // 컨트롤러를 지정합니다.
                  initialChildSize: controller.isFullScreen.value ? 1.0 : 0.4, // 초기 높이 설정
                  minChildSize: 0.4, // 최소 높이
                  maxChildSize: 1.0, // 최대 높이
                  expand: true,
                  builder: (BuildContext context, ScrollController scrollController) {
                    // 스크롤 컨트롤러는 리스트뷰에 전달됩니다.

                    // 바텀시트의 확장 정도를 모니터링하기 위해 NotificationListener를 사용합니다.
                    return NotificationListener<DraggableScrollableNotification>(
                      onNotification: (notification) {
                        // 바텀시트가 완전히 확장되었을 때
                        if (notification.extent == 1.0 && !controller.isFullScreen.value) {
                          setState(() {
                            controller.isFullScreen.value = true; // fullscreen 상태로 변경
                          });
                        }
                        // 바텀시트가 축소되었을 때
                        else if (notification.extent < 1.0 && controller.isFullScreen.value) {
                          setState(() {
                            controller.isFullScreen.value = false; // fullscreen 상태 해제
                          });
                        }
                        return true;
                      },
                      child: Obx(
                            () => Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: controller.isFullScreen.value
                                ? BorderRadius.zero
                                : BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              // 바텀시트가 fullscreen이 아닐 때 손잡이 표시
                              if (!controller.isFullScreen.value)
                                Container(
                                  width: 40,
                                  height: 6,
                                  margin: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              // 선택된 카테고리가 '관심'일 때 서브 카테고리 버튼들을 표시합니다.
                              if (controller.selectedCategory.value == '관심') ...[
                                Divider(color: Colors.grey[200], thickness: 1, height: 0),
                                SubCategoryButtons(
                                  selectedSubCategory: controller.selectedSubCategory.value,
                                  onSubCategorySelected: controller.onSubCategorySelected, // ViewModel에서 처리
                                ),
                              ],
                              Divider(color: Colors.grey[200], thickness: 1, height: 5),
                              // 목록의 개수를 표시합니다.
                              Padding(
                                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      const Text(
                                        '목록 ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${controller.displayedItems.length}개',
                                        style: const TextStyle(
                                            color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // 리스트뷰를 표시합니다.
                              Expanded(
                                child: controller.displayedItems.isEmpty
                                    ? const Center(child: Text('저장된 항목이 없습니다.'))
                                    : HomemapListView(
                                  items: controller.displayedItems,
                                  controller: controller,
                                  scrollController: scrollController, // 리스트뷰에 스크롤 컨트롤러 전달
                                ),
                              ),
                            ],
                          ),
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
      // floatingActionButton을 사용하여 '지도보기' 버튼을 표시합니다.
      floatingActionButton: Obx(
            () => controller.isFullScreen.value
            ? Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              onTap: () {
                // '지도보기' 버튼을 눌렀을 때 바텀시트의 높이를 0.4로 줄입니다.
                controller.isFullScreen.value = false; // fullscreen 상태 해제

                // DraggableScrollableController를 사용하여 바텀시트의 높이를 0.4로 설정합니다.
                draggableScrollableController.animateTo(
                  0.4, // 원하는 높이 (0.4)
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
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
            : const SizedBox.shrink(), // '지도보기' 버튼을 표시하지 않을 때 빈 위젯 반환
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
