import 'dart:math'; // Random 클래스를 사용하기 위해 math 패키지 가져오기
import 'package:flutter/material.dart'; // Flutter UI 구성 요소 패키지
import 'package:project_island/section/feed/view/postcard_view.dart'; // Postcard 화면 가져오기
import 'package:project_island/section/feed/view/search_view.dart'; // SearchFocus 화면 가져오기
import 'package:project_island/section/common/feed_my_page common/src/components/grid_widget.dart'; // GridWidget 파일 가져오기

class FeedView extends StatefulWidget {
  const FeedView({Key? key}) : super(key: key); // 생성자

  @override
  State<FeedView> createState() => _FeedViewState(); // 상태 객체 생성
}

// _FeedViewState 클래스, 상태 관리를 담당
class _FeedViewState extends State<FeedView> {
  List<List<int>> groupBox = [[], [], []]; // 3개의 빈 리스트로 이루어진 groupBox 리스트 생성
  List<int> groupIndex = [0, 0, 0]; // 3개의 0으로 초기화된 groupIndex 리스트 생성

  @override
  void initState() {
    super.initState(); // 상태 초기화 메서드 호출
    _loadInitialData(); // 초기 데이터 로드
  }

  // 초기 데이터를 로드하는 함수
  void _loadInitialData() {
    if (groupIndex.isNotEmpty) {
      for (var i = 0; i < 20; i++) { // 초기 데이터는 20개만 로드
        var minIndex = groupIndex.indexOf(groupIndex.reduce((value, element) => value < element ? value : element)); // 가장 작은 값을 가진 인덱스 찾기
        var size = 1; // 기본 크기 1로 설정
        if (minIndex != 1) {
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
        if (minIndex != 1) {
          size = Random().nextInt(100) % 2 == 0 ? 1 : 2; // 랜덤으로 1 또는 2 할당
        }
        groupBox[minIndex].add(size); // 해당 인덱스에 크기 추가
        groupIndex[minIndex] += size; // 해당 인덱스 크기 업데이트
      }
      setState(() {}); // 상태 업데이트
    }
  }

  Widget _appbar() {
    // 커스텀 앱바 위젯
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchView())); // SearchFocus 화면으로 이동
            },
            child: Container(
              height: 40, // 텍스트 필드의 높이 설정
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10), // 패딩 설정
              margin: const EdgeInsets.only(left: 10), // 왼쪽 여백 설정
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), // 모서리를 둥글게 설정
                color: Colors.white, // 배경색 설정
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey, // 그림자 색상
                    blurRadius: 1, // 그림자 흐림 정도
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      ' 키워드를 검색해보세요', // 검색창 텍스트
                      style: TextStyle(
                        fontSize: 18, // 텍스트 크기
                        color: Color(0xff838383), // 텍스트 색상
                      ),
                    ),
                  ),
                  Icon(Icons.search, color: Colors.green), // 돋보기 아이콘 색상 설정
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _body() {
    // 피드 내용 위젯
    return Padding(
      padding: const EdgeInsets.only(top: 10.0), // 앱바 밑에 10의 패딩 추가
      child: GridWidget(
        groupBox: groupBox, // groupBox를 GridWidget에 전달
        onTap: (index, jndex) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Postcard(), // Postcard 화면으로 이동
            ),
          );
        },
        onLoadMore: _loadMoreData, // 무한 스크롤 시 데이터 로드 함수 연결
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appbar(), // 커스텀 앱바 사용
      ),
      body: _body(), // 피드 내용 표시
    );
  }
}
