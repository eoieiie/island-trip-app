import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController = TextEditingController(); // 검색창 입력을 위한 컨트롤러
  final Function(String) onSearchSubmitted; // 검색 제출 콜백 추가

  CustomAppBar({super.key, required this.onSearchSubmitted}); // 생성자에서 콜백 받음

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0, // AppBar 자체의 그림자 제거
      titleSpacing: 0, // 타이틀과 leading 사이의 간격을 0으로 설정
      title: Container(
        height: 40, // 세로 길이를 줄임
        margin: const EdgeInsets.only(left: 10, right: 16), // 왼쪽 여백 줄이고 검색창 오른쪽 여백 추가
        decoration: BoxDecoration(
          color: Colors.white, // 배경 흰색
          borderRadius: BorderRadius.circular(12), // 둥근 테두리
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // 그림자 색상
              blurRadius: 1, // 그림자 흐림 정도
              offset: Offset(0, 0.5), // 그림자 위치
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 18), // 왼쪽에 여백 추가
                child: TextField(
                  controller: searchController, // 검색창에 텍스트 컨트롤러 추가
                  decoration: const InputDecoration(
                    hintText: '장소 검색', // Placeholder
                    border: InputBorder.none, // 기본 테두리 제거
                    contentPadding: EdgeInsets.symmetric(vertical: 10), // 텍스트 입력과 테두리 간격 조정
                  ),
                  onSubmitted: onSearchSubmitted, // 검색어 제출 시 콜백 실행
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12), // 검색 아이콘 오른쪽 여백
              child: GestureDetector(
                onTap: () {
                  // 검색 버튼을 눌렀을 때 검색 실행
                  onSearchSubmitted(searchController.text);
                },
                child: Icon(
                  Icons.search,
                  size: 24, // 검색 아이콘의 크기 조정
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8), // 뒤로가기 버튼 왼쪽 여백 유지
        child: Container(
          height: 48, // 높이 통일 (정사각형 유지)
          width: 48,  // 너비 통일 (정사각형 유지)
          decoration: BoxDecoration(
            color: Colors.white, // 버튼 배경 흰색
            borderRadius: BorderRadius.circular(12), // 둥근 모서리
            boxShadow: const [
              BoxShadow(
                color: Colors.black26, // 그림자 색상
                blurRadius: 1, // 그림자 흐림 정도
                offset: Offset(0, 0.5), // 그림자 위치
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black), // 뒤로가기 아이콘
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56); // AppBar의 높이를 맞춤
}
