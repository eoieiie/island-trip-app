import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_island/section/saved/viewmodel/saved_controller.dart';
import 'package:project_island/section/saved/view/saved_listview.dart';
import 'package:project_island/section/saved/view/category_button.dart';


class SavedView extends StatefulWidget {
  const SavedView({Key? key}) : super(key: key);

  @override
  State<SavedView> createState() => SavedViewState();
}

class SavedViewState extends State<SavedView> {
  final SavedController controller = Get.put(SavedController());
  String selectedCategory = '섬'; // 기본 카테고리

  @override
  void initState() {
    super.initState();
    controller.getSavedItems(); // 저장된 항목을 불러옴
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("관심목록", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 카테고리 버튼 추가
          CategoryButtons(
            selectedCategory: selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
                controller.getSavedItems(); // 카테고리에 따라 항목을 가져옴
              });
            },
          ),
          Divider(
            color: Colors.grey[200],
            thickness: 1,
            height: 5,
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
                  _buildItemCountText(controller, selectedCategory),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.savedItems.isEmpty) {
                return const Center(child: Text("저장된 항목이 없습니다."));
              } else {
                final filteredItems = controller.savedItems
                    .where((item) => item.category == selectedCategory)
                    .toList();

                return SavedListView(items: filteredItems, controller: controller);
              }
            }),
          ),
        ],
      ),
    );
  }
}

// 수정된 _buildItemCountText 함수
Widget _buildItemCountText(SavedController controller, String selectedCategory) {
  return Obx(() {
    final filteredItems = controller.savedItems
        .where((item) => item.category == selectedCategory)
        .toList();

    return Text(
      '${filteredItems.length}개',
      style: const TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
    );
  });
}
