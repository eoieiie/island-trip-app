import 'package:flutter/material.dart'
;
class CategoryButtons extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryButtons({super.key, required this.selectedCategory, required this.onCategorySelected});

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

  const SubCategoryButtons({super.key, required this.selectedSubCategory, required this.onSubCategorySelected});

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
