import 'package:flutter/material.dart';
import 'package:project_island/section/home/view/magazine_view.dart'; // import 추가
import 'package:project_island/section/home/view/place_detail_view.dart'; // 추가

class IslandDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('울릉도'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 울릉도 관련 매거진
            _buildSection(
              context,
              title: '울릉도 관련 매거진(눌러봐)',
              child: Container(
                height: 200, // 높이 설정
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, // 예제 항목 수
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MagazineView()),
                        );
                      },
                      child: Container(
                        width: 160,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        color: Colors.grey[300],
                        child: Center(child: Text('매거진 $index')),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // 울릉도 찐 후기
            _buildSection(
              context,
              title: '울릉도 찐 후기',
              child: Container(
                height: 200, // 높이 설정
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, // 예제 항목 수
                  itemBuilder: (context, index) {
                    return Container(
                      width: 160,
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      color: Colors.grey[300],
                      child: Center(child: Text('후기 $index')),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // 울릉도 맛집
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '울릉도 맛집',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      _showFullScreenDialog(context, '울릉도 맛집 전체보기');
                    },
                    child: Text('전체보기'),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCuisineButton('한식'),
                _buildCuisineButton('중식'),
                _buildCuisineButton('일식'),
                _buildCuisineButton('양식'),
                _buildCuisineButton('카페'),
              ],
            ),
            SizedBox(height: 16.0),

            // 가게 리스트
            Container(
              height: 400, // 높이 설정
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                scrollDirection: Axis.vertical,
                itemCount: 8, // 예제 항목 수
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlaceDetailView()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '가게 이름 $index',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4.0),
                          Text('위치: 예시 위치 $index'),
                          SizedBox(height: 4.0),
                          Text('별점: 4.7'),
                          Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              onPressed: () {
                                // 저장 버튼 동작 구현
                              },
                              child: Text('저장'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // 전체보기 버튼은 '울릉도 맛집' 섹션에서만 활성화
              if (title == '울릉도 맛집')
                TextButton(
                  onPressed: () {
                    _showFullScreenDialog(context, title);
                  },
                  child: Text('전체보기'),
                ),
            ],
          ),
          SizedBox(height: 8.0),
          child,
        ],
      ),
    );
  }

  Widget _buildCuisineButton(String label) {
    return ElevatedButton(
      onPressed: () {
        // 버튼 클릭 동작 구현
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
      ),
      child: Text(label),
    );
  }

  void _showFullScreenDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  title: Text(title),
                  automaticallyImplyLeading: false, // 이전 화면으로 돌아가기 버튼 숨기기
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildCuisineButton('한식'),
                              _buildCuisineButton('중식'),
                              _buildCuisineButton('일식'),
                              _buildCuisineButton('양식'),
                              _buildCuisineButton('카페'),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0),
                        _buildStoreInfo('가게 이름 1', '음식카테고리 1', '위치 1', 4.7),
                        SizedBox(height: 16.0),
                        _buildStoreInfo('가게 이름 2', '음식카테고리 2', '위치 2', 4.7),
                        SizedBox(height: 16.0),
                        _buildStoreInfo('가게 이름 3', '음식카테고리 3', '위치 3', 4.7),
                        SizedBox(height: 16.0),
                        _buildStoreInfo('가게 이름 4', '음식카테고리 4', '위치 4', 4.7),
                        SizedBox(height: 16.0),
                        // 자세히보기 버튼 추가
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PlaceDetailView()),
                              );
                            },
                            child: Text('자세히보기'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('닫기'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStoreInfo(String storeName, String category, String location, double rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 가게 이름과 음식 카테고리 (컨테이너 외부)
        Text(
          '$storeName ($category)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        SizedBox(height: 8.0),
        // 회색 컨테이너 (컨테이너 내부)
        Container(
          width: double.infinity, // 화면 가득 차도록 설정
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('위치: $location'),
              SizedBox(height: 4.0),
              Text('별점: $rating'),
            ],
          ),
        ),
      ],
    );
  }
}
