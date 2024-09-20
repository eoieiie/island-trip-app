import 'package:flutter/material.dart';

class LowerCategoryButtons extends StatelessWidget {
  final String selectedSubCategory;
  final ValueChanged<String> onSubCategorySelected;
  final List<String> subCategories;
  final bool showAll;

  const LowerCategoryButtons({
    Key? key,
    required this.selectedSubCategory,
    required this.onSubCategorySelected,
    required this.subCategories,
    this.showAll = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // '전체' 버튼 클릭 시 모든 하위 카테고리 표시
    List<String> displayedSubCategories = showAll ? subCategories : subCategories.take(3).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 15),
          // '전체' 버튼
          _buildCategoryButton('전체', '✔️', () {
            onSubCategorySelected('전체');
          }),
          // 하위 카테고리들 표시
          ...displayedSubCategories.map((subCategory) {
            return _buildCategoryButton(subCategory, _getEmoji(subCategory), () {
              onSubCategorySelected(subCategory);
            });
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category, String emoji, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(40, 28),
          backgroundColor: selectedSubCategory == category ? Colors.green : Colors.white,
          foregroundColor: selectedSubCategory == category ? Colors.white : Colors.black,
          side: BorderSide(
            color: selectedSubCategory == category ? Colors.green : Colors.grey[200]!,
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



String _getEmoji(String category) {
    switch (category) {
      case '낚시':
        return '🎣';
      case '스쿠버 다이빙':
        return '🤿';
      case '계곡':
        return '🏞️';
      case '바다':
        return '🏖️';
      case '서핑':
        return '🏄‍♂️';
      case '휴향림':
        return '🌳';
      case '산책길':
        return '🌿';
      case '역사':
        return '🏛️';
      case '수상 레저':
        return '🐬';
      case '자전거':
        return '🚴‍♂️';
      case '한식':
        return '🇰🇷';
      case '양식':
        return '🇺🇸';
      case '일식':
        return '🇯🇵';
      case '중식':
        return '🇨🇳';
      case '분식':
        return '🍜';
      case '기타':
        return '🍽️';
      case '커피':
        return '☕';
      case '베이커리':
        return '🥐';
      case '아이스크림/빙수':
        return '🍧';
      case '차':
        return '🍵';
      case '과일/주스':
        return '🍎';
      case '전통 디저트':
        return '🍰';
      case '모텔':
        return '🏩';
      case '호텔/리조트':
        return '🏨';
      case '캠핑':
        return '🏕️';
      case '게하/한옥':
        return '🏡';
      case '펜션':
        return '🏠';
      default:
        return '📍';
    }
  }


// lower_category_buttons.dart

class SubCategoryButtons extends StatelessWidget {
  final String selectedSubCategory;
  final ValueChanged<String> onSubCategorySelected;

  const SubCategoryButtons({
    Key? key,
    required this.selectedSubCategory,
    required this.onSubCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 하위 카테고리 버튼 리스트 예시 (필요에 맞게 수정 가능)
    List<String> subCategories = ['섬', '명소/놀거리', '음식', '카페', '숙소'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: subCategories.map((subCategory) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              onPressed: () => onSubCategorySelected(subCategory),
              style: ElevatedButton.styleFrom(
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
        }).toList(),
      ),
    );
  }
}
