import 'package:flutter/material.dart';

class PlaceDetailView extends StatefulWidget {
  @override
  _PlaceDetailViewState createState() => _PlaceDetailViewState();
}

class _PlaceDetailViewState extends State<PlaceDetailView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('천지연 울릉도점'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            // 건물 사진과 별점, 저장 버튼
            Container(
              color: Colors.grey[300], // 배경 색상
              child: Column(
                children: [
                  Container(
                    height: 200, // 건물 사진 높이
                    color: Colors.grey[400], // 사진 대신 색상으로 대체
                    child: Center(child: Text('건물 사진')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '별점: 4.7',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8.0),
                            IconButton(
                              icon: Icon(Icons.star, color: Colors.amber),
                              onPressed: () {
                                // 별점 클릭 동작 구현
                              },
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // 저장 버튼 동작 구현
                          },
                          child: Text('저장'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // TabBar
            Container(
              color: Colors.white,
              child: TabBar(
                tabs: [
                  Tab(text: '자세한정보'),
                  Tab(text: '리뷰'),
                ],
              ),
            ),
            // TabBarView
            Expanded(
              child: TabBarView(
                children: [
                  _buildDetailedInfo(),
                  _buildReviews(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedInfo() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.0),
          // 지도
          Container(
            height: 200,
            color: Colors.grey[300], // 지도 대신 색상으로 대체
            child: Center(child: Text('지도')),
          ),
          SizedBox(height: 16.0),
          // 가게 정보
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '가게 정보\n주소\n전화번호\n메뉴 등',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          5, // 예제 리뷰 수
              (index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 8.0),
                      Text(
                        '리뷰어 $index',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '리뷰 내용 $index',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 16.0),
                        // 가로 스크롤 가능한 정사각형 그리드
                        Container(
                          height: 120,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(
                              5, // 예제 이미지 수
                                  (imageIndex) {
                                return Container(
                                  width: 120, // 너비 설정
                                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300], // 이미지 대신 색상으로 대체
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(child: Text('사진 $imageIndex')),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
