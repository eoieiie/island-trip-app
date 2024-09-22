import 'package:flutter/material.dart';

// 상위 카테고리 버튼을 모두 포함하는 클래스
class UpperCategoryButtons extends StatelessWidget {
  final String selectedCategory; // 현재 선택된 상위 카테고리
  final ValueChanged<String> onCategorySelected; // 상위 카테고리 선택 이벤트 핸들러

  const UpperCategoryButtons({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // 상위 카테고리 버튼들을 가로로 스크롤 가능하게 설정
      child: Row(
        children: [
          const SizedBox(width: 15), // 좌측 간격
          _buildCategoryButton('관심'), // 관심 카테고리 버튼 생성
          _buildCategoryButton('명소/놀거리'), // 명소/놀거리 카테고리 버튼 생성
          _buildCategoryButton('음식'), // 음식 카테고리 버튼 생성
          _buildCategoryButton('카페'), // 카페 카테고리 버튼 생성
          _buildCategoryButton('숙소'), // 숙소 카테고리 버튼 생성
        ],
      ),
    );
  }

  // 상위 카테고리 버튼을 빌드하는 함수
  Widget _buildCategoryButton(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: ElevatedButton(
        onPressed: () => onCategorySelected(category), // 버튼 클릭 시 상위 카테고리 선택 이벤트 핸들러 호출
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(40, 28),
          backgroundColor: selectedCategory == category ? Colors.white : Colors.white, // 선택 여부에 따른 배경색
          foregroundColor: selectedCategory == category ? Colors.green : Colors.black, // 선택 여부에 따른 텍스트 색상
          side: BorderSide(
            color: selectedCategory == category ? Colors.green : Colors.grey[200]!, // 선택 여부에 따른 테두리 색상
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // 둥근 테두리
          ),
        ),
        child: Text(
          category, // 카테고리 이름만 표시 (이모지 제거됨)
          style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500), // 텍스트 스타일
        ),
      ),
    );
  }
}
