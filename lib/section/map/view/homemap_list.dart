import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_island/section/map/view/homemap_view.dart';
import 'package:project_island/section/map/viewmodel/homemap_list_controller.dart';
import 'package:project_island/section/map/view/homemap_listview.dart';
import 'package:project_island/section/map/widget/custom_appbar.dart'; // CustomAppBar 위젯이 정의된 파일 경로로 수정
import 'package:project_island/section/map/widget/category_buttons.dart'; // CategoryButtons 위젯이 정의된 파일 경로로 수정
import 'package:project_island/section/map/model/island_model.dart'; // IslandModel이 정의된 파일 경로로 수정

class HomemapList extends StatefulWidget {
  final String islandName; // 선택된 섬의 이름을 전달받기 위한 변수 추가

  const HomemapList({Key? key, required this.islandName}) : super(key: key); // 생성자 수정

  @override
  HomemapListState createState() => HomemapListState();
}

class HomemapListState extends State<HomemapList> {
  final HomemapListController controller = HomemapListController();
  String selectedCategory = '관심';
  String selectedSubCategory = '';
  List<IslandModel> displayedItems = []; // 화면에 표시될 아이템 리스트 추가

  @override
  void initState() {
    super.initState();
    // 초기 카테고리를 섬 이름으로 설정하여 해당 섬의 기본 정보를 로드
    selectedCategory = widget.islandName;  // 수정된 부분
    _loadInitialItems(); // 초기 아이템 로드
  }

  // 초기 아이템을 로드하는 함수 추가
  void _loadInitialItems() async {
    final results = await controller.getItemsByCategory(selectedCategory);
    setState(() {
      displayedItems = results;
    });
  }

  // 검색창에서 제출 시 호출될 함수 수정
  void _onSearchSubmitted(String query) async {
    if (query.isNotEmpty) {
      String modifiedQuery = '${widget.islandName} $query';
      final results = await controller.getItemsByCategory(modifiedQuery);
      print('검색 결과 수: ${results.length}'); // 검색 결과 개수 출력
      setState(() {
        displayedItems = results; // 검색 결과로 리스트 업데이트
      });
    }
  }

  // 카테고리 선택 시 호출되는 함수 추가
  void _onCategorySelected(String category) async {
    String modifiedCategory = '${widget.islandName} $category';
    final results = await controller.getItemsByCategory(modifiedCategory);
    setState(() {
      selectedCategory = category;
      selectedSubCategory = '';
      displayedItems = results;
    });
  }

  // 서브 카테고리 선택 시 호출되는 함수 추가
  void _onSubCategorySelected(String subCategory) async {
    String modifiedSubCategory = '${widget.islandName} $subCategory';
    final results = await controller.getItemsByCategory(modifiedSubCategory);
    setState(() {
      selectedSubCategory = subCategory;
      displayedItems = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onSearchSubmitted: _onSearchSubmitted, // 검색 기능을 위한 콜백 추가
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CategoryButtons(
            selectedCategory: selectedCategory,
            onCategorySelected: _onCategorySelected, // 수정된 부분
          ),
          if (selectedCategory == '관심') ...[
            Divider(
              color: Colors.grey[200],
              thickness: 1,
              height: 0,
            ),
            SubCategoryButtons(
              selectedSubCategory: selectedSubCategory,
              onSubCategorySelected: _onSubCategorySelected, // 수정된 부분
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
                  Text(
                    '${displayedItems.length}개', // 아이템 수 표시
                    style: const TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: displayedItems.isEmpty
                ? const Center(child: Text('저장된 항목이 없습니다.'))
                : HomemapListView(items: displayedItems, controller: controller), // displayedItems로 리스트뷰 생성
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: GestureDetector(
            onTap: () {
              Get.to(() => HomeMapView());
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
}
