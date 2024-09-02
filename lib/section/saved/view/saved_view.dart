import 'package:flutter/material.dart';
import 'package:project_island/section/saved/viewmodel/saved_controller.dart';
import 'package:project_island/section/saved/view/saved_listview.dart';
import 'package:project_island/section/saved/model/saved_model.dart';

class SavedView extends StatefulWidget {
  const SavedView({Key? key}) : super(key: key); // Key 매개변수 추가 및 const 사용

  @override
  State<SavedView> createState() => SavedViewState(); // 클래스 이름을 공개적으로 변경
}

class SavedViewState extends State<SavedView> {
  final SavedController controller = SavedController();
  String selectedCategory = '섬';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("관심목록", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // const 사용
        automaticallyImplyLeading: false, // 뒤로가기 버튼을 제거
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CategoryButtons(
            selectedCategory: selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
              });
            },
          ),
          const Divider( // const 사용
            color: Colors.grey,
            thickness: 1,
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 5, bottom: 10), // const 사용
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const Text( // const 사용
                    '목록 ',
                    style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  _buildItemCountText(),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SavedItem>>(
              future: controller.getSavedItems(selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator()); // const 사용
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('저장된 항목이 없습니다.')); // const 사용
                } else {
                  final items = snapshot.data!;
                  return SavedListView(items: items, controller: controller);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCountText() {
    return FutureBuilder<List<SavedItem>>(
      future: controller.getSavedItems(selectedCategory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text( // const 사용
            '불러오는 중...',
            style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
          );
        } else if (snapshot.hasError) {
          return const Text( // const 사용
            '오류 발생',
            style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text( // const 사용
            '0개',
            style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
          );
        } else {
          return Text(
            '${snapshot.data!.length}개',
            style: const TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold), // const 사용
          );
        }
      },
    );
  }
}

class CategoryButtons extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryButtons({
    super.key, // 'key'를 super parameter로 변경
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 15), // const 사용
          _buildCategoryButton('섬'),
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
      padding: const EdgeInsets.symmetric(horizontal: 1.0), // const 사용
      child: ElevatedButton(
        onPressed: () => onCategorySelected(category),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(40, 28), // const 사용
          backgroundColor: selectedCategory == category ? Colors.green : Colors.white,
          foregroundColor: selectedCategory == category ? Colors.white : Colors.black,
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
          style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500), // const 사용
        ),
      ),
    );
  }
}
