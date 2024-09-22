import 'package:flutter/material.dart';

class LowerCategoryButtons extends StatefulWidget {
  final String selectedSubCategory; // 현재 선택된 하위 카테고리
  final ValueChanged<String> onSubCategorySelected; // 하위 카테고리 선택 이벤트 핸들러
  final List<String> subCategories; // 표시할 하위 카테고리 목록
  final String selectedCategory; // 상위 카테고리 선택 상태
  final VoidCallback onAllSelected; // '전체' 버튼 선택 시 처리할 콜백 (전체 검색)

  const LowerCategoryButtons({
    Key? key,
    required this.selectedSubCategory,
    required this.onSubCategorySelected,
    required this.subCategories,
    required this.selectedCategory,
    required this.onAllSelected, // 콜백 추가
  }) : super(key: key);

  @override
  _LowerCategoryButtonsState createState() => _LowerCategoryButtonsState();
}

class _LowerCategoryButtonsState extends State<LowerCategoryButtons> {
  bool showMore = false; // 꺽쇠 버튼 눌렀을 때 나머지 버튼을 표시할지 여부
  String selectedSubCategory = '전체'; // 기본적으로 '전체' 버튼 선택 상태

  @override
  void initState() {
    super.initState();
    // 처음부터 '전체' 버튼이 눌린 상태로 설정하고 전체 검색 기능 호출
    widget.onAllSelected(); // 전체 버튼 기능 실행
  }

  @override
  Widget build(BuildContext context) {
    // 하위 카테고리가 없으면 아무것도 표시하지 않음
    if (widget.subCategories.isEmpty) {
      return const SizedBox.shrink(); // 하위 카테고리가 없을 경우 빈 공간으로 대체
    }

    // '관심' 카테고리일 때는 '전체' 버튼 없이 하위 카테고리만 표시
    if (widget.selectedCategory == '관심') {
      return _buildSingleLineButtons(widget.subCategories);
    }

    // '전체' 버튼을 제외한 하위 카테고리들
    List<String> filteredSubCategories = widget.subCategories.where((category) => category != '기타').toList();

    // 음식과 숙소 카테고리일 때는 모든 버튼을 한 줄에 나열
    if (widget.selectedCategory == '음식' || widget.selectedCategory == '숙소') {
      return _buildSingleLineWithAllButton(filteredSubCategories);
    }

    // 첫 번째 줄에 표시할 버튼들 (최대 3개 + '전체' 버튼 포함)
    List<String> initialSubCategories = filteredSubCategories.take(3).toList();

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 첫 번째 줄: '전체' 버튼 포함 최대 4개
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // '전체' 버튼
                  _buildCategoryButton('전체', '✔️', () {
                    setState(() {
                      selectedSubCategory = '전체';
                      widget.onAllSelected(); // '전체' 버튼을 눌렀을 때 전체 검색 실행
                    });
                  }),
                  ...initialSubCategories.map((subCategory) {
                    return _buildCategoryButton(subCategory, _getEmoji(subCategory), () {
                      setState(() {
                        selectedSubCategory = subCategory;
                        widget.onSubCategorySelected(subCategory); // 하위 카테고리 선택 시 호출
                      });
                    });
                  }).toList(),
                ],
              ),
            ),

            // 두 번째 줄: 나머지 카테고리 버튼 표시
            if (showMore && filteredSubCategories.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filteredSubCategories.skip(3).map((subCategory) {
                      return _buildCategoryButton(subCategory, _getEmoji(subCategory), () {
                        setState(() {
                          selectedSubCategory = subCategory;
                          widget.onSubCategorySelected(subCategory); // 하위 카테고리 선택 시 호출
                        });
                      });
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),

        // 오른쪽 끝에 있는 FloatingActionButton으로 꺽쇠 버튼 추가
        if (filteredSubCategories.length > 3)
          Positioned(
            right: 8,
            top: 5,
            child: Container(
              width: 35,
              height: 35,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    showMore = !showMore;
                  });
                },
                backgroundColor: Colors.grey.withOpacity(0.6),
                child: Icon(
                  showMore ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white,
                  size: 20, // 아이콘 크기 조정
                ),
              ),
            ),
          ),
      ],
    );
  }

  // 음식, 숙소 카테고리에서 한 줄로 모든 버튼을 나열하는 함수
  Widget _buildSingleLineWithAllButton(List<String> subCategories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // '전체' 버튼
          _buildCategoryButton('전체', '✔️', () {
            setState(() {
              selectedSubCategory = '전체';
              widget.onAllSelected(); // 전체 검색 실행
            });
          }),
          ...subCategories.map((subCategory) {
            return _buildCategoryButton(subCategory, _getEmoji(subCategory), () {
              setState(() {
                selectedSubCategory = subCategory;
                widget.onSubCategorySelected(subCategory);
              });
            });
          }).toList(),
        ],
      ),
    );
  }

  // 첫 번째 줄에 버튼들을 한 줄로 나열하는 함수 (관심 카테고리에서 사용)
  Widget _buildSingleLineButtons(List<String> subCategories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: subCategories.map((subCategory) {
          return _buildCategoryButton(subCategory, _getEmoji(subCategory), () {
            setState(() {
              selectedSubCategory = subCategory;
              widget.onSubCategorySelected(subCategory); // 하위 카테고리 선택 시 호출
            });
          });
        }).toList(),
      ),
    );
  }

  // 개별 하위 카테고리 버튼을 빌드하는 함수
  Widget _buildCategoryButton(String category, String emoji, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(40, 28),
          backgroundColor: selectedSubCategory == category
              ? Colors.white
              : Colors.white, // 선택 여부에 따른 배경색
          foregroundColor: selectedSubCategory == category
              ? Colors.green
              : Colors.black, // 선택 여부에 따른 텍스트 색상
          side: BorderSide(
            color: selectedSubCategory == category
                ? Colors.green
                : Colors.grey[200]!, // 테두리 색상
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // 둥근 테두리
          ),
        ),
        child: Text(
          '$emoji $category', // 이모지와 카테고리 텍스트
          style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500), // 텍스트 스타일
        ),
      ),
    );
  }

  // 각 카테고리에 맞는 이모지를 반환하는 함수
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
        return ''; // 기본 이모지
    }
  }
}
