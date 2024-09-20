import 'package:flutter/material.dart';
import 'package:project_island/section/map/widget/upper_category_buttons.dart';
import 'package:project_island/section/map/widget/lower_category_buttons.dart';

class CategoryButtons extends StatelessWidget {
  final String selectedCategory;
  final String selectedSubCategory;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<String> onSubCategorySelected;
  final bool showAllSubCategories;

  const CategoryButtons({
    Key? key,
    required this.selectedCategory,
    required this.selectedSubCategory,
    required this.onCategorySelected,
    required this.onSubCategorySelected,
    this.showAllSubCategories = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UpperCategoryButtons(
          selectedCategory: selectedCategory,
          onCategorySelected: onCategorySelected,
        ),
        const Divider(),
        if (selectedCategory == '관심')
          LowerCategoryButtons(
            selectedSubCategory: selectedSubCategory,
            onSubCategorySelected: onSubCategorySelected,
            subCategories: ['섬', '명소/놀거리', '음식', '카페', '숙소'],
            showAll: showAllSubCategories,
          )
        else if (selectedCategory == '명소/놀거리')
          LowerCategoryButtons(
            selectedSubCategory: selectedSubCategory,
            onSubCategorySelected: onSubCategorySelected,
            subCategories: ['낚시', '스쿠버 다이빙', '계곡', '바다', '서핑', '휴향림', '산책길', '역사', '수상 레저', '자전거'],
            showAll: showAllSubCategories,
          )
        else if (selectedCategory == '음식')
            LowerCategoryButtons(
              selectedSubCategory: selectedSubCategory,
              onSubCategorySelected: onSubCategorySelected,
              subCategories: ['한식', '양식', '일식', '중식', '분식', '기타'],
              showAll: showAllSubCategories,
            )
          else if (selectedCategory == '카페')
              LowerCategoryButtons(
                selectedSubCategory: selectedSubCategory,
                onSubCategorySelected: onSubCategorySelected,
                subCategories: ['커피', '베이커리', '아이스크림/빙수', '차', '과일/주스', '전통 디저트', '기타'],
                showAll: showAllSubCategories,
              )
            else if (selectedCategory == '숙소')
                LowerCategoryButtons(
                  selectedSubCategory: selectedSubCategory,
                  onSubCategorySelected: onSubCategorySelected,
                  subCategories: ['모텔', '호텔/리조트', '캠핑', '게하/한옥', '펜션'],
                  showAll: showAllSubCategories,
                ),
      ],
    );
  }
}
