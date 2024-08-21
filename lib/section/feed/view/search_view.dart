import 'package:flutter/material.dart';
import 'package:get/get.dart'; // GetX 패키지 가져오기
import 'package:project_island/section/feed/viewmodel/search_controller.dart'; // SearchController 가져오기
import 'package:project_island/section/feed/view/search_focus_view.dart'; // SearchFocus 화면 가져오기

class SearchView extends StatelessWidget {
  final SearchViewController controller = Get.put(
      SearchViewController()); // SearchViewController 인스턴스 생성 및 주입

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 화면을 클릭하면 키보드를 숨김 굿!!
      },
      child: Scaffold(
        appBar: _appBar(context), // AppBar 생성
        body: Obx(() => _buildBody(context)), // Obx를 사용해 상태 변화를 감지하며 Body 생성
      ),
    );
  }

  // AppBar를 빌드하는 메서드
  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      // AppBar의 그림자 제거
      backgroundColor: Colors.white,
      // AppBar 배경색을 흰색으로 설정
      leading: Container(
        margin: const EdgeInsets.all(4.5), // 왼쪽 여백을 추가
        child: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          // X 버튼 아이콘을 검정색으로 설정
          onPressed: () {
            Get.back(); // GetX의 Get.back() 메서드를 사용하여 이전 화면으로 돌아가기 //Navigator.pop(context);
          },
          padding: const EdgeInsets.all(8),
          // 버튼의 패딩 설정
          constraints: const BoxConstraints(
            minWidth: 30, // 최소 너비 설정
            minHeight: 30, // 최소 높이 설정
          ),
          splashRadius: 15,
          // 클릭 영역 설정
          iconSize: 20, // 아이콘 크기 설정
        ),
        decoration: BoxDecoration(
          color: Colors.white, // X 버튼의 배경색을 흰색으로 설정
          borderRadius: BorderRadius.circular(15), // 둥근 모서리 설정
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, // 그림자 색상 설정
              blurRadius: 3, // 그림자 흐림 정도 설정
              offset: Offset(0, 0), // 그림자 위치 설정
            ),
          ],
        ),
        alignment: Alignment.center, // 아이콘 중앙 정렬
      ),
      titleSpacing: 10,
      // 검색창과 X 버튼 사이의 거리 조정
      title: _searchField(context),
      // 검색 필드 생성
      actions: const [], // 추가적인 액션 없음
    );
  }

  // 검색 필드를 빌드하는 메서드
  Widget _searchField(BuildContext context) {
    return Container(
      height: 40,
      // 텍스트 필드의 높이 설정
      margin: const EdgeInsets.only(right: 10),
      // 오른쪽 여백 설정
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      // 좌우 패딩 설정
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
              decoration: const InputDecoration(
                hintText: '키워드를 검색해보세요',
                // 기본 힌트 텍스트
                hintStyle: TextStyle(
                  fontSize: 18, // 텍스트 크기 설정
                  color: Color(0xff838383), // 텍스트 색상 설정
                ),
                contentPadding: EdgeInsets.only(left: 5),
                // 텍스트 패딩 설정
                isDense: true,
                // 텍스트 필드 크기 조정
                border: InputBorder.none, // 테두리 제거
              ),
              onSubmitted: (query) {
                controller.search(query); // 사용자가 검색어를 입력한 후 제출했을 때 검색 기능 호출
              },
            ),
          ),
          const Icon(Icons.search, color: Colors.green), // 돋보기 아이콘 색상 설정
        ],
      ),
    );
  }

  // Body 전체를 빌드하는 메서드
  Widget _buildBody(BuildContext context) {
    if (controller.query.isEmpty || (controller.searchResults.isEmpty &&
        controller.searchHistory.isNotEmpty)) {
      return _recentSearchList(context); // 최근 검색 기록 화면 표시
    } else {
      return _recentSearchList(context); // 검색 기록 화면 표시
    }
  }

  /* 이상하게 되는 놈 // Body 전체를 빌드하는 메서드
  Widget _buildBody(BuildContext context) {
    // 검색어가 비어 있고 검색 기록이 있을 때 최근 검색 기록을 표시
    if (controller.query.isEmpty || (controller.searchResults.isEmpty && controller.searchHistory.isNotEmpty)) {
      return _recentSearchList(context);
    }
    // 검색어는 있지만 데이터베이스에서 결과를 찾지 못한 경우 '검색 결과가 없어요' 화면을 표시
    else if (controller.searchResults.isEmpty && controller.query.isNotEmpty) {
      return _noResults(context);
    }
    // 검색어에 대해 검색 결과가 있는 경우 검색 결과 리스트를 표시
    else {
      return _resultsList(context);
    }
  } */

  // 최근 검색 기록 화면을 빌드하는 메서드
  Widget _recentSearchList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 내용물들을 왼쪽 정렬
      children: [
        Container(
          color: Colors.white, // 배경색을 흰색으로 설정
          padding: const EdgeInsets.all(10.0), // 모든 면에 패딩 적용
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양 끝에 각각 배치
            children: [
              const Text(
                '최근 검색', // 최근 검색 텍스트
                style: TextStyle(
                  fontSize: 16, // 텍스트 크기 설정
                  fontWeight: FontWeight.bold, // 텍스트 굵게 설정
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.clearSearchHistory(); // 전체 삭제 클릭 시 검색 기록 전체 삭제
                },
                child: const Text(
                  '전체 삭제', // 전체 삭제 텍스트
                  style: TextStyle(
                    color: Colors.green, // 텍스트 색상 설정
                    fontSize: 14, // 텍스트 크기 설정
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.searchHistory.isEmpty) {
              return const Center(
                child: Text(
                  '최근 검색 기록이 없습니다.', // 검색 기록이 없을 때 텍스트 표시
                  style: TextStyle(color: Colors.grey), // 텍스트 색상 설정
                ),
              );
            } else {
              return ListView.builder(
                itemCount: controller.searchHistory.length, // 검색 기록 항목 개수
                itemBuilder: (context, index) {
                  return ListTile(
                    tileColor: Colors.white, // 리스트 아이템의 배경색을 흰색으로 설정
                    title: Text(controller.searchHistory[index]), // 검색 기록 표시
                    trailing: IconButton(
                      icon: const Icon(Icons.clear), // X 버튼 아이콘
                      onPressed: () {
                        controller.removeSearchHistoryItem(
                            index); // 특정 검색 기록 삭제
                      },
                    ),
                    onTap: () {
                      controller.search(controller
                          .searchHistory[index]); // 기록 항목을 클릭하면 해당 항목으로 검색 실행
                      Get.to(() =>
                          SearchFocusView(
                              query: controller.searchHistory[index],
                              results: [])); // 검색어를 인자로 SearchFocusView로 이동
                    },
                  );
                },
              );
            }
          }),
        ),
      ],
    );
  }

  // 검색 결과가 없을 때 화면을 빌드하는 메서드
  Widget _noResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
        children: [
          const Icon(Icons.search_off, size: 80, color: Colors.grey),
          // 검색 결과 없음 아이콘
          Text(
            "'${controller.query.value}'", // 입력된 검색어를 표시
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold), // 텍스트 스타일 설정
          ),
          const Text('검색결과가 없어요', style: TextStyle(color: Colors.grey)),
          // 검색 결과가 없다는 텍스트 표시
        ],
      ),
    );
  }

  // 검색 결과 리스트를 빌드하는 메서드
  Widget _resultsList(BuildContext context) {
    return ListView.builder(
      itemCount: controller.searchResults.length, // 검색 결과 개수
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(controller.searchResults[index]), // 검색 결과 표시
          trailing: IconButton(
            icon: const Icon(Icons.clear), // X 버튼 아이콘
            onPressed: () {
              controller.removeSearchResult(index); // 검색 결과 항목 제거
            },
          ),
          onTap: () {
            // 검색 결과가 있을 때 SearchFocusView로 이동
            Get.to(() =>
                SearchFocusView(
                  query: controller.searchResults[index], // 검색어 전달
                  results: controller.searchResults.toList(), // 검색 결과 리스트 전달
                ));
          },
        );
      },
    );
  }
}