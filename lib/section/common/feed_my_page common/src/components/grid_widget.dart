
import 'package:flutter/material.dart'; // Flutter UI 구성 요소 패키지

class GridWidget extends StatefulWidget {
  final List<List<int>> groupBox; // 그룹 박스 리스트
  final Function(int, int) onTap; // 각 요소 탭 시 실행될 콜백 함수
  final Function onLoadMore; // 더 많은 데이터를 로드하기 위한 콜백 함수

  // GridWidget 생성자
  const GridWidget({
    Key? key,
    required this.groupBox, // groupBox와 onTap은 필수 매개변수
    required this.onTap,
    required this.onLoadMore, // onLoadMore는 무한 스크롤을 위해 추가된 필수 매개변수
  }) : super(key: key);

  @override
  _GridWidgetState createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러 초기화

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      // 스크롤이 끝에 도달했을 때 onLoadMore 호출
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        widget.onLoadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // 스크롤 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _scrollController, // 스크롤 컨트롤러 연결
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3개의 열
        childAspectRatio: 1, // 정사각형 비율
        mainAxisSpacing: 1, // 항목 간 세로 간격
        crossAxisSpacing: 1, // 항목 간 가로 간격
      ),
      itemCount: widget.groupBox.length * widget.groupBox[0].length, // 총 항목 수
      itemBuilder: (context, index) {
        final rowIndex = index % widget.groupBox.length;
        final columnIndex = index ~/ widget.groupBox.length;

        if (rowIndex < widget.groupBox.length && columnIndex < widget.groupBox[rowIndex].length) {
          return GestureDetector(
            onTap: () => widget.onTap(rowIndex, columnIndex), // 탭 시 콜백 호출
            child: Container(
              height: MediaQuery.of(context).size.width * 0.33 * widget.groupBox[rowIndex][columnIndex], // 높이 설정
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white), // 경계선 설정
                color: Colors.primaries[index % Colors.primaries.length], // 색상 설정
              ),
            ),
          );
        } else {
          return SizedBox.shrink(); // 빈 공간 반환
        }
      },
    );
  }
}

