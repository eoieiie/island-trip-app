import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('바텀 시트 예제'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // 검색 버튼 기능
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => BottomSheetWidget(),
            );
          },
          child: Text('바텀 시트 열기'),
        ),
      ),
    );
  }
}

class BottomSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // 위쪽 바
              Container(
                width: 40,
                height: 5,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // 놀거리 종류 체크박스들
              buildCategorySection('놀거리 종류', [
                '전체',
                '낚시',
                '스쿠버 다이빙',
                '계곡',
                '바다',
                '서핑',
                '휴양림',
                '산책길',
                '역사',
                '수상 레저',
                '자전거',
              ]),
              SizedBox(height: 20),
              // 음식 종류 체크박스들
              buildCategorySection('음식 종류', [
                '전체',
                '한식',
                '양식',
                '일식',
                '중식',
                '분식',
                '기타',
              ]),
              SizedBox(height: 20),
              // 음식 종류 체크박스들 (두번째 섹션)
              buildCategorySection('음식 종류', [
                '전체',
                '커피',
                '베이커리',
                '아이스크림/빙수',
                '차',
                '과일/주스',
                '전통 디저트',
                '기타',
              ]),
              Spacer(),
              // 하단 버튼들
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 재로딩 버튼
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      // 재로딩 버튼 기능
                    },
                  ),
                  // 확인 버튼
                  ElevatedButton(
                    onPressed: () {
                      // 확인 버튼 기능
                    },
                    child: Text('확인'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // 카테고리 섹션 빌드 함수
  Widget buildCategorySection(String title, List<String> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: categories.map((category) {
            return FilterChip(
              label: Text(category),
              onSelected: (selected) {
                // 선택 상태 처리
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CustomBottomSheet(),
  ));
}
