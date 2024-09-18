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
  final DraggableScrollableController draggableScrollableController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    controller.onCategorySelected(widget.islandName); // 초기 카테고리 설정
    controller.loadInitialItems(widget.islandName); // 초기 데이터 로드
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 검색 기능이 있는 커스텀 앱바를 사용합니다.
      appBar: CustomAppBar(
        onSearchSubmitted: controller.onSearchSubmitted, // ViewModel에서 처리
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
            const MapBackground(), // 배경에 네이버 맵 표시
            Column(
              children: [
                // Container로 감싸고 배경색을 흰색으로 설정합니다.
                Container(
                  color: Colors.white, // 상위 카테고리 바의 배경색을 흰색으로 설정
                  child: Obx(() => CategoryButtons(
                    selectedCategory: controller.selectedCategory.value,
                    onCategorySelected: controller.onCategorySelected, // ViewModel에서 처리
                  )),
                ),
                Expanded(
                  child: DraggableScrollableSheet(
                    controller: draggableScrollableController,
                    initialChildSize: controller.isFullScreen.value ? 1.0 : 0.4,
                    minChildSize: 0.4,
                    maxChildSize: 1.0,
                    expand: true,
                    builder: (BuildContext context, ScrollController scrollController) {
                      return BottomSheetContent(
                        controller: controller,
                        scrollController: scrollController,
                        draggableController: draggableScrollableController,
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
            controller.isFullScreen.value = false; // fullscreen 상태 해제
            // 바텀시트 높이를 0.4로 조정
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

// 나머지 위젯들은 이전과 동일합니다...


// 배경에 네이버 맵을 표시하는 위젯
class MapBackground extends StatelessWidget {
  const MapBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.blueGrey,
        child: const Center(
          child: Text(
            '네이버 맵',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// 바텀시트의 내용을 표시하는 위젯
class BottomSheetContent extends StatelessWidget {
  final HomemapListController controller;
  final ScrollController scrollController;
  final DraggableScrollableController draggableController;

  const BottomSheetContent({
    Key? key,
    required this.controller,
    required this.scrollController,
    required this.draggableController,
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
                  height: 6,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              if (controller.selectedCategory.value == '관심') ...[
                Divider(color: Colors.grey[200], thickness: 1, height: 0),
                SubCategoryButtons(
                  selectedSubCategory: controller.selectedSubCategory.value,
                  onSubCategorySelected: controller.onSubCategorySelected,
                ),
              ],
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
                child: controller.displayedItems.isEmpty
                    ? const Center(child: Text('저장된 항목이 없습니다.'))
                    : HomemapListView(
                  items: controller.displayedItems,
                  controller: controller,
                  scrollController: scrollController,
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
