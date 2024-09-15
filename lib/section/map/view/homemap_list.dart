import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_island/section/map/view/homemap_listview.dart';
import 'package:project_island/section/map/viewmodel/homemap_list_controller.dart';
import 'package:project_island/section/map/widget/custom_appbar.dart';
import 'package:project_island/section/map/widget/category_buttons.dart';
import 'package:project_island/section/map/model/island_model.dart';

class HomemapList extends StatefulWidget {
  const HomemapList({super.key});

  @override
  HomemapListState createState() => HomemapListState();
}

class HomemapListState extends State<HomemapList> {
  final HomemapListController controller = HomemapListController(); // controller 선언
  String selectedCategory = ''; // 기본 카테고리 설정
  String selectedSubCategory = ''; // 기본 하위 카테고리 설정

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
              future: selectedCategory.isEmpty
                  ? controller.getFiveIslands()
                  : controller.getItemsByCategory(selectedSubCategory.isEmpty ? selectedCategory : selectedSubCategory),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('저장된 항목이 없습니다.'));
                } else {
                  final items = snapshot.data!;
                  return HomemapListView(
                    items: items,
                    controller: controller, // controller 전달
                    selectedCategory: selectedCategory, // selectedCategory 전달
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCountText() {
    return FutureBuilder<List<IslandModel>>(
      // 기본 카테고리 선택이 없으면 5개의 섬 목록을, 카테고리가 선택되면 해당 카테고리의 장소 목록을 불러옴
      future: selectedCategory.isEmpty
          ? controller.getFiveIslands() // 기본 카테고리 선택 안됨 -> 5개의 섬 목록 불러옴
          : controller.getItemsByCategory(selectedSubCategory.isEmpty ? selectedCategory : selectedSubCategory),
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
