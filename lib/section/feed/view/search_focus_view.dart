import 'package:flutter/material.dart'; // Flutter UI 구성 요소 패키지
import 'package:get/get.dart'; // GetX 패키지 가져오기
import 'package:project_island/section/feed/viewmodel/search_focus_controller.dart'; // Controller 가져오기

// 검색 결과를 보여주는 페이지
class SearchFocusView extends GetView<SearchFocusController> {
  final String query;
  final List<String> results; // 검색 결과를 받을 리스트

  // 생성자에서 검색어와 검색 결과를 받음
  SearchFocusView({required this.query, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context), // 수정된 AppBar 빌드 메서드 호출
      body: _body(), // TabBarView로 구성된 페이지 본문
    );
  }

  // 수정된 AppBar 빌드 메서드
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0, // 그림자 제거
      backgroundColor: Colors.white, // AppBar 배경색을 흰색으로 설정
      leading: Container(
        margin: const EdgeInsets.only(left: 10), // 왼쪽 여백을 추가
        child: IconButton(
          icon: const Icon(Icons.close, color: Colors.black), // X 버튼 아이콘을 검정색으로 설정
          onPressed: () {
            Get.back(); // 이전 화면으로 돌아가기
          },
          padding: const EdgeInsets.all(8), // 버튼의 패딩 설정
          constraints: const BoxConstraints(
            minWidth: 30, // 최소 너비 설정
            minHeight: 30, // 최소 높이 설정
          ),
          splashRadius: 15, // 클릭 영역 설정
          iconSize: 20, // 아이콘 크기 설정
        ),
        decoration: BoxDecoration(
          color: Colors.white, // X 버튼의 배경색을 흰색으로 설정
          borderRadius: BorderRadius.circular(15), // 둥근 모서리 설정
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, // 그림자 색상 설정
              blurRadius: 4, // 그림자 흐림 정도 설정
              offset: Offset(2, 2), // 그림자 위치 설정
            ),
          ],
        ),
        alignment: Alignment.center, // 아이콘 중앙 정렬
      ),
      titleSpacing: 10, // 검색창과 X 버튼 사이의 거리 조정
      title: _searchField(context), // 검색 필드 생성
      actions: const [], // 추가적인 액션 없음
      bottom: _tabMenu(), // Tab 메뉴 추가
    );
  }

  // 검색 필드를 빌드하는 메서드
  Widget _searchField(BuildContext context) {
    return Container(
      height: 40, // 텍스트 필드의 높이 설정
      margin: const EdgeInsets.only(right: 10), // 오른쪽 여백 설정
      padding: const EdgeInsets.symmetric(horizontal: 10.0), // 좌우 패딩 설정
      decoration: BoxDecoration(
        color: Colors.white, // 배경색 설정
        borderRadius: BorderRadius.circular(8.0), // 둥근 모서리 설정
        boxShadow: const [
          BoxShadow(
            color: Colors.grey, // 그림자 색상 설정
            blurRadius: 1, // 그림자 흐림 정도 설정
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: TextEditingController(text: query), // 검색어를 검색창에 표시
              decoration: const InputDecoration(
                hintText: '키워드를 검색해보세요', // 기본 힌트 텍스트
                hintStyle: TextStyle(
                  fontSize: 18, // 텍스트 크기 설정
                  color: Color(0xff838383), // 텍스트 색상 설정
                ),
                contentPadding: EdgeInsets.only(left: 5), // 텍스트 패딩 설정
                isDense: true, // 텍스트 필드 크기 조정
                border: InputBorder.none, // 테두리 제거
              ),
              onSubmitted: (value) {
                controller.search(value); // 검색 기능 호출
              },
            ),
          ),
          const Icon(Icons.search, color: Colors.green), // 돋보기 아이콘 색상 설정
        ],
      ),
    );
  }

  // Tab 메뉴를 구성하는 메서드
  PreferredSizeWidget _tabMenu() {
    return PreferredSize(
      child: Container(
        height: AppBar().preferredSize.height, // AppBar의 높이
        width: double.infinity, // 가로 길이 설정
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xffe4e4e4)))), // 하단 테두리
        child: TabBar(
          controller: controller.tabController, // Controller에서 가져온 TabController 사용
          indicatorColor: Colors.black, // 인디케이터 색상 설정
          tabs: [
            _tabMenuOne('추천'), // 첫 번째 탭 메뉴
            _tabMenuOne('장소'), // 두 번째 탭 메뉴
            _tabMenuOne('태그'), // 세 번째 탭 메뉴
          ],
        ),
      ),
      preferredSize: Size.fromHeight(AppBar().preferredSize.height), // AppBar 높이 설정
    );
  }

  // 각 탭의 이름을 표시하는 위젯
  Widget _tabMenuOne(String menu) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0), // 위아래 패딩 설정
      child: Text(
        menu,
        style: const TextStyle(fontSize: 15, color: Colors.black), // 텍스트 스타일 설정
      ),
    );
  }

  // TabBarView에 표시될 본문 구성
  Widget _body() {
    return TabBarView(
      controller: controller.tabController, // Controller에서 가져온 TabController 사용
      children: [
        _buildRecommendationPage(), // 첫 번째 탭 페이지 (추천)
        _buildPlacePage(), // 두 번째 탭 페이지 (장소)
        _buildTagPage(), // 세 번째 탭 페이지 (태그)
      ],
    );
  }

  // '추천' 페이지 구성
  Widget _buildRecommendationPage() {
    return results.isEmpty
        ? Center(
      child: Text('검색결과가 없어요'), // 검색 결과가 없을 때 표시
    )
        : ListView.builder(
      itemCount: results.length, // 검색 결과 개수
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]), // 검색 결과 표시
        );
      },
    );
  }

  // '장소' 페이지 구성
  Widget _buildPlacePage() {
    return Center(
      child: Text('장소 페이지'), // 예시 텍스트
    );
  }

  // '태그' 페이지 구성
  Widget _buildTagPage() {
    return Center(
      child: Text('태그 페이지'), // 예시 텍스트
    );
  }
}
