import 'package:flutter/material.dart';
import 'package:project_island/section/saved/viewmodel/saved_controller.dart';
import 'package:project_island/section/saved/view/saved_listview.dart';
import 'package:project_island/section/saved/model/saved_model.dart';

class SavedView extends StatefulWidget {
  const SavedView({Key? key}) : super(key: key);

  @override
  State<SavedView> createState() => SavedViewState();
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
        title: const Text("관심목록", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
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
          Divider(
            color: Colors.grey[200],
            thickness: 1,
            height: 15,
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
            child: FutureBuilder<List<SavedItem>>(
              future: controller.getSavedItems(selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('저장된 항목이 없습니다.'));
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

class CategoryButtons extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryButtons({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 15),
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
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: ElevatedButton(
        onPressed: () => onCategorySelected(category),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(40, 28),
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
          style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
