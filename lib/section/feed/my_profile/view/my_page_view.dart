import 'dart:math'; // Random 클래스를 사용하기 위해 math 패키지 가져오기
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 라이브러리를 가져오기
import 'package:get/get.dart'; // GetX 라이브러리 가져오기

import 'package:project_island/section/my_page/view/profile_edit_view.dart'; // 프로필 편집 화면 가져오기
import 'package:project_island/section/my_page/view/setting_view.dart'; // 설정 화면 가져오기
import 'package:project_island/section/feed/view/photo_detail_view.dart'; // 사진 상세보기 화면 가져오기
import 'package:project_island/section/my_page/viewmodel/my_page_controller.dart'; // MypageController 가져오기
import 'package:project_island/section/common/feed_my_page common/src/components/grid_widget.dart'; // GridWidget 파일 가져오기

// MyPageView 위젯의 상태를 관리하는 StatefulWidget입니다.
class MyPageView extends StatefulWidget {
  @override
  _MyPageViewState createState() => _MyPageViewState();
}

// _MyPageViewState 클래스는 MyPageView의 상태를 관리
class _MyPageViewState extends State<MyPageView> with SingleTickerProviderStateMixin {
  MypageController _controller = Get.put(MypageController()); // MypageController 인스턴스 생성 및 주입
  List<List<int>> groupBox = [[], [], []]; // 3개의 빈 리스트로 이루어진 groupBox 리스트 생성
  List<int> groupIndex = [0, 0, 0]; // 3개의 0으로 초기화된 groupIndex 리스트 생성

  TabController? _tabController; // TabController 선언

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 3개의 탭을 관리하는 TabController 초기화

    _loadInitialData(); // 초기 데이터를 로드
  }

  // 초기 데이터를 로드하는 함수
  void _loadInitialData() {
    if (groupIndex.isNotEmpty) {
      for (var i = 0; i < 20; i++) { // 초기 데이터는 20개만 로드
        var minIndex = groupIndex.indexOf(groupIndex.reduce((value, element) => value < element ? value : element)); // 가장 작은 값을 가진 인덱스 찾기
        var size = 1; // 기본 크기 1로 설정
        if (minIndex != 1) { // 인덱스가 1이 아니면
          size = Random().nextInt(100) % 2 == 0 ? 1 : 2; // 랜덤으로 1 또는 2 할당
        }
        groupBox[minIndex].add(size); // 해당 인덱스에 크기 추가
        groupIndex[minIndex] += size; // 해당 인덱스 크기 업데이트
      }
      setState(() {}); // 상태 업데이트
    }
  }

  // 스크롤 시 더 많은 데이터를 로드하는 함수
  void _loadMoreData() {
    if (groupIndex.isNotEmpty) {
      for (var i = 0; i < 20; i++) { // 추가로 20개 데이터 로드
        var minIndex = groupIndex.indexOf(groupIndex.reduce((value, element) => value < element ? value : element)); // 가장 작은 값을 가진 인덱스 찾기
        var size = 1; // 기본 크기 1로 설정
        if (minIndex != 1) { // 인덱스가 1이 아니면
          size = Random().nextInt(100) % 2 == 0 ? 1 : 2; // 랜덤으로 1 또는 2 할당
        }
        groupBox[minIndex].add(size); // 해당 인덱스에 크기 추가
        groupIndex[minIndex] += size; // 해당 인덱스 크기 업데이트
      }
      setState(() {}); // 상태 업데이트
    }
  }

  // 프로필 편집 페이지로 이동하는 함수입니다.
  void _goToProfileEditPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileEditView()), // 프로필 편집 페이지로 이동
    );
  }

  // 설정 페이지로 이동하는 함수입니다.
  void _goToSettingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingView()), // 설정 페이지로 이동
    );
  }

  @override
  void dispose() {
    _tabController?.dispose(); // TabController 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // 뒤로 가기 버튼
          onPressed: () {
            Navigator.of(context).pop(); // 이전 화면으로 돌아가기
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz), // 점 3개 아이콘(케밥 메뉴)
            onPressed: _goToSettingPage, // 설정 페이지로 이동
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0, // 그림자 제거
      ),
      body: Column(
        children: [
          // 프로필 섹션
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0), // 좌우 패딩 설정
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50, // 더 큰 원형 아바타 반지름 설정
                  backgroundColor: Colors.grey, // 배경색 설정
                ),
                SizedBox(height: 16), // 간격 조정
                Text(
                  '불금엔제주턱시도', // 사용자 이름
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // 텍스트 스타일 설정
                ),
                Text(
                  '남만 넘치는 여행을 좋아합니다.', // 사용자 한 줄 소개
                  style: TextStyle(fontSize: 16, color: Colors.grey), // 텍스트 스타일 설정
                ),
              ],
            ),
          ),
          const SizedBox(height: 24), // 프로필과 탭 간 간격

          // 탭 섹션
          Expanded(
            child: Column(
              children: [
                TabBar(
                  controller: _tabController, // TabController 연결
                  tabs: const [
                    Tab(text: '전체'), // 첫 번째 탭
                    Tab(text: '사진'), // 두 번째 탭
                    Tab(text: '영상'), // 세 번째 탭
                  ],
                  indicatorColor: Colors.black, // 밑줄 색상 설정
                  indicatorWeight: 3, // 밑줄 두께 설정
                  indicatorSize: TabBarIndicatorSize.tab, // 밑줄이 탭의 전체 크기를 차지하도록 설정
                  labelColor: Colors.black, // 선택된 탭의 텍스트 색상
                  unselectedLabelColor: Colors.grey, // 선택되지 않은 탭의 텍스트 색상
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController, // TabController 연결
                    children: [
                      _buildTabContent(), // 첫 번째 페이지 내용
                      _buildTabContent(), // 두 번째 페이지 내용
                      _buildTabContent(), // 세 번째 페이지 내용
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 각 탭에 대한 콘텐츠를 빌드하는 메서드
  Widget _buildTabContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0), // 좌우 10의 패딩을 추가
      child: GridWidget(
        groupBox: groupBox, // groupBox를 GridWidget에 전달
        onTap: (index, jndex) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoDetailView(), // PhotoDetailView 화면으로 이동
            ),
          );
        },
        onLoadMore: _loadMoreData, // 더 많은 데이터를 로드하기 위한 콜백 함수
      ),
    );
  }
}
