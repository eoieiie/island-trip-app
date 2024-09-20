import 'package:flutter/material.dart';

class UpperCategoryButtons extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const UpperCategoryButtons({
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
          _buildCategoryButton('관심', '🌟'),
          _buildCategoryButton('명소/놀거리', '🎯'),
          _buildCategoryButton('음식', '🍽️'),
          _buildCategoryButton('카페', '☕'),
          _buildCategoryButton('숙소', '🏨'),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category, String emoji) {
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
          '$emoji $category',
          style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
