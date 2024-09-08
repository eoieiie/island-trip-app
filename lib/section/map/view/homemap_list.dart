import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_island/section/map/view/homemap_view.dart';
import 'package:project_island/section/map/viewmodel/homemap_list_controller.dart';
import 'package:project_island/section/map/view/homemap_listview.dart';
import 'package:project_island/section/map/widget/custom_appbar.dart'; // CustomAppBar 위젯이 정의된 파일 경로로 수정
import 'package:project_island/section/map/widget/category_buttons.dart'; // CategoryButtons 위젯이 정의된 파일 경로로 수정
import 'package:project_island/section/map/model/island_model.dart'; // IslandModel이 정의된 파일 경로로 수정

class HomemapList extends StatefulWidget {
  const HomemapList({super.key});

  @override
  HomemapListState createState() => HomemapListState();
}

class HomemapListState extends State<HomemapList> {
  final HomemapListController controller = HomemapListController();
  String selectedCategory = '관심';
  String selectedSubCategory = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CategoryButtons(
            selectedCategory: selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
                selectedSubCategory = '';
              });
            },
          ),
          if (selectedCategory == '관심') ...[
            Divider(
              color: Colors.grey[200],
              thickness: 1,
              height: 0,
            ),
            SubCategoryButtons(
              selectedSubCategory: selectedSubCategory,
              onSubCategorySelected: (subCategory) {
                setState(() {
                  selectedSubCategory = subCategory;
                });
              },
            ),
          ],
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
                  _buildItemCountText(),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<IslandModel>>(
              future: controller.getItemsByCategory(selectedSubCategory.isEmpty ? selectedCategory : selectedSubCategory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('저장된 항목이 없습니다.'));
                } else {
                  final items = snapshot.data!;
                  return HomemapListView(items: items, controller: controller); // IslandModel을 SavedListView에 전달
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: GestureDetector(
            onTap: () {
              Get.to(HomeMapView());
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
                  const Icon(
                    Icons.pin_drop_sharp,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '지도보기',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

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
