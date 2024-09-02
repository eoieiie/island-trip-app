import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_island/section/map/view/homemap_view.dart';
import 'package:project_island/section/map/viewmodel/homemap_list_controller.dart'; // ViewModel 클래스 변경
import 'package:project_island/section/map/model/island_model.dart';
import 'package:project_island/section/map/view/homemap_listview.dart';

class HomemapList extends StatefulWidget {
  const HomemapList({super.key}); // 'key'를 super parameter로 변경

  @override
  HomemapListState createState() => HomemapListState();
}

class HomemapListState extends State<HomemapList> {
  final HomemapListController controller = HomemapListController(); // HomemapListController 인스턴스 생성
  String selectedCategory = '관심'; // 기본 카테고리 설정 없음, String? selectedCategory;면 기본 카테고리 설정 X
  String selectedSubCategory = ''; // 하위 카테고리 설정

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
                selectedSubCategory = ''; // 메인 카테고리를 선택하면 하위 카테고리 초기화
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
          child: FloatingActionButton.extended(
            onPressed: () {
              Get.to(HomeMapView());
            },
            label: const Text('지도 보기', style: TextStyle(color: Colors.white, fontSize: 14)),
            icon: const Icon(Icons.pin_drop_sharp, color: Colors.white, size: 15),
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            extendedPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
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

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key}); // 'key'를 super parameter로 변경

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text('관심 목록', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 3,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CategoryButtons extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryButtons({super.key, required this.selectedCategory, required this.onCategorySelected}); // 'key'를 super parameter로 변경

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 15),
          _buildCategoryButton('관심'),
          _buildCategoryButton('명소/놀거리'),
          _buildCategoryButton('음식'),
          _buildCategoryButton('카페'),
          _buildCategoryButton('숙소'),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: ElevatedButton(
        onPressed: () => onCategorySelected(category),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(40, 28),
          backgroundColor: Colors.white,
          foregroundColor: selectedCategory == category ? Colors.green : Colors.black,
          side: BorderSide(
            color: selectedCategory == category ? Colors.green : Colors.grey[200]!,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          category,
          style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class SubCategoryButtons extends StatelessWidget {
  final String selectedSubCategory;
  final ValueChanged<String> onSubCategorySelected;

  const SubCategoryButtons({super.key, required this.selectedSubCategory, required this.onSubCategorySelected}); // 'key'를 super parameter로 변경

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 15),
          ...['섬', '명소/놀거리', '음식', '카페', '숙소'].map((subCategory) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              child: ElevatedButton(
                onPressed: () => onSubCategorySelected(subCategory),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(40, 28),
                  backgroundColor: selectedSubCategory == subCategory ? Colors.green : Colors.white,
                  foregroundColor: selectedSubCategory == subCategory ? Colors.white : Colors.black,
                  side: BorderSide(
                    color: selectedSubCategory == subCategory ? Colors.green : Colors.grey[200]!,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  subCategory,
                  style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
