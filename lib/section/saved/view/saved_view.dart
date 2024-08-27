import 'package:flutter/material.dart';


import 'package:project_island/section/saved/viewmodel/saved_controller.dart';
import 'package:project_island/section/saved/view/saved_listview.dart';

class SavedView extends StatefulWidget {
  @override
  _SavedViewState createState() => _SavedViewState();
}

class _SavedViewState extends State<SavedView> {
  final SavedController controller = SavedController(); // SavedController 인스턴스 생성
  String selectedCategory = '섬'; // 기본 카테고리 설정

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 앱바 설정
        centerTitle: true, // 제목을 중앙에 정렬
        backgroundColor: Colors.white, // 앱바 배경색 흰색
        elevation: 0, // 그림자 제거
        title: Text("관심목록", style: TextStyle(fontSize:20, fontWeight: FontWeight.bold)), // 앱바 제목
      ),
      backgroundColor: Colors.white, // 앱바 배경색 흰색
      body: Column(
        // 전체 내용을 담는 Column
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // 가로 스크롤 가능
            child: Row(
              // 버튼을 담는 Row
              children: [
                SizedBox(width: 15), // 왼쪽 벽과의 간격을 추가
                _buildCategoryButton('섬'), // 섬 카테고리 버튼
                _buildCategoryButton('명소/놀거리'), // 명소/놀거리 카테고리 버튼
                _buildCategoryButton('음식'), // 음식 카테고리 버튼
                _buildCategoryButton('카페'), // 카페 카테고리 버튼
                _buildCategoryButton('숙소'), // 숙소 카테고리 버튼
              ],
            ),
          ),
          Divider( // 카테고리 버튼과 목록 사이에 밑줄 추가
            color: Colors.grey[200], // 밑줄 색상 연한 회색
            thickness: 1, // 밑줄 두께
            height: 15, // 밑줄 높이
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 5, bottom: 10), // 패딩 설정
            child: Align(
              alignment: Alignment.centerLeft, // 왼쪽 정렬
              child: RichText(
                // RichText 위젯 사용
                text: TextSpan(
                  // TextSpan을 사용해 스타일을 각각 적용
                  children: [
                    TextSpan(
                      text: '목록 ', // "목록" 텍스트
                      style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold), // 검은색 텍스트 스타일
                    ),
                    TextSpan(
                      text: '${controller.getSavedItems(selectedCategory).length}개', // 목록 개수 텍스트
                      style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold), // 초록색 텍스트 스타일
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SavedListView(
              controller: controller,
              selectedCategory: selectedCategory,
            ), // 분리된 ListView 위젯 사용
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    // 카테고리 버튼 위젯
    double buttonWidth;

    // 카테고리 이름에 따라 버튼의 가로 길이 설정
    switch (category) {
      case '섬':
        buttonWidth = 40;
        break;
      case '음식':
        buttonWidth = 50;
        break;
      case '카페':
        buttonWidth = 50;
        break;
      case '숙소':
        buttonWidth = 60;
        break;
      case '명소/놀거리':
        buttonWidth = 70;
        break;
      default:
        buttonWidth = 30; // 기본값
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0), // 가로 패딩 설정
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCategory = category; // 카테고리 선택
          });
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(buttonWidth, 35), // 버튼의 최소 크기 설정 (가로, 세로)
          backgroundColor: selectedCategory == category ? Colors.green : Colors.white, // 선택되지 않은 버튼의 배경색 흰색
          foregroundColor: selectedCategory == category ? Colors.white : Colors.black, // 선택된 버튼 텍스트는 흰색, 그렇지 않으면 검정색
          side: BorderSide( // 버튼 테두리 설정
            color: selectedCategory == category ? Colors.green : Colors.grey[200]!, // 선택된 버튼은 녹색 테두리, 그렇지 않으면 연한 회색
            width: 1, // 테두리 두께
          ),
          shape: RoundedRectangleBorder( // 버튼 모양 설정
            borderRadius: BorderRadius.circular(20), // 둥근 모서리 설정
          ),
        ),
        child: Text(
          category,
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500), // 텍스트 크기 조정
        ), // 버튼 텍스트
      ),
    );
  }
}

