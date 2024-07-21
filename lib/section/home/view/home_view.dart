import 'package:flutter/material.dart';
import 'package:project_island/section/home/view/island_detail_view.dart'; // import 확인

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _title = '홈';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Column(
        children: [
          // 상단 버튼
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IslandDetailView()), // 이동할 화면
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // 버튼 색상
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text('섬 자세히 보기'),

            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 첫 번째 섹션
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '매거진',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          height: 250,
                          color: Colors.grey[300],
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '갈매기 까까, 울릉도',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        '사진 울릉도 고슴도치길 226-11',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        '#가성비 #스쿠버다이빙 #탁트인바다 #~~~',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          '스노쿨링 - 스쿠버다이빙 명소',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        // 가로 스크롤 가능 GridView, 1줄
                        Container(
                          height: 300, // 높이 조정
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                            ),
                            itemCount: 20, // 아이템 수
                            itemBuilder: (context, index) {
                              return AspectRatio(
                                aspectRatio: 1 / 2, // 세로가 긴 비율
                                child: Card(
                                  child: Center(child: Text('Item $index')),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 두 번째 섹션
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '낚시',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16.0),
                        // 가로 스크롤 가능 GridView, 1줄
                        Container(
                          height: 300,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                            ),
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              return AspectRatio(
                                aspectRatio: 1 / 2,
                                child: Card(
                                  child: Center(child: Text('Item $index')),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 세 번째 섹션
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '전망대',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16.0),
                        // 가로 스크롤 가능 GridView, 1줄
                        Container(
                          height: 300,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                            ),
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              return AspectRatio(
                                aspectRatio: 1 / 2,
                                child: Card(
                                  child: Center(child: Text('Item $index')),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 네 번째 섹션
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '해수욕장',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16.0),
                        // 가로 스크롤 가능 GridView, 1줄
                        Container(
                          height: 300,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                            ),
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              return AspectRatio(
                                aspectRatio: 1 / 2,
                                child: Card(
                                  child: Center(child: Text('Item $index')),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
