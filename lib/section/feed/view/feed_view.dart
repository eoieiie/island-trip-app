import 'dart:math'; // Random 클래스를 사용하기 위해 math 패키지 가져오기
import 'package:flutter/material.dart'; // Flutter UI 구성 요소 패키지
import 'package:get/get.dart';

import 'package:project_island/section/feed/view/review_write_view.dart'; // ReviewWriteView 파일 가져오기
import 'package:project_island/section/feed/view/search_focus_view.dart'; // SearchFocus 파일 가져오기
// import 'package:project_island/section/feed/view/photo_detail_view.dart'; // PhotoDetailView 파일 가져오기

import 'package:project_island/section/common/map_view.dart'; // MapView 파일 가져오기
import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'package:project_island/section/feed/repository/map_marker_repository.dart';
import 'package:project_island/section/feed/viewmodel/map_marker_viewmodel.dart';

import 'package:project_island/section/common/feed_my_page common/src/components/post_widget.dart';
import 'package:project_island/section/feed/model/post_model.dart';
// import 'package:project_island/section/my_page/model/user_model.dart'; // IUser 클래스가 정의된 파일


class FeedView extends StatefulWidget { // FeedView라는 Stateful 위젯 선언
  const FeedView({Key? key}) : super(key: key); // 생성자

  @override
  State<FeedView> createState() => _FeedViewState(); // 상태 객체 생성
}

// _FeedViewState 클래스, 상태 관리를 담당
class _FeedViewState extends State<FeedView> {
  // FeedView의 상태 클래스
  List<List<int>> groupBox = [[], [], []]; // 3개의 빈 리스트로 이루어진 groupBox 리스트 생성
  List<int> groupIndex = [0, 0, 0]; // 3개의 0으로 초기화된 groupIndex 리스트 생성

  final MapMarkerViewmodel viewModel = Get.put(MapMarkerViewmodel(
      repository: MapMarkerRepository(
          apiUrl: 'https://your-api-url.com/places')));

  @override
  void initState() {
    // 상태 초기화 메서드
    super.initState();

    if (groupIndex.isNotEmpty) { // groupIndex가 비어있지 않으면
      for (var i = 0; i < 100; i++) { // 100번 반복
        var minIndex = groupIndex.indexOf(groupIndex.reduce((value, element) =>
        value < element
            ? value
            : element)); // 가장 작은 값을 가진 인덱스 찾기
        var size = 1; // 기본 크기 1로 설정
        if (minIndex != 1) { // 인덱스가 1이 아니면
          size = Random().nextInt(100) % 2 == 0 ? 1 : 2; // 랜덤으로 1 또는 2 할당
        }
        groupBox[minIndex].add(size); // 해당 인덱스에 크기 추가
        groupIndex[minIndex] += size; // 해당 인덱스 크기 업데이트
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: _appbar(),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.feed_rounded)),
              Tab(icon: Icon(Icons.map)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _body(),
            Obx(() {
              if (viewModel.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              return _mapView(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _appbar() {
    // 커스텀 앱바 위젯
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (
                      context) => const SearchFocus())); // SearchFocus 화면으로 이동
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              // 패딩 설정
              margin: const EdgeInsets.only(left: 15),
              // 왼쪽 여백 설정
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6), // 모서리를 둥글게 설정
                color: const Color(0xffefefef), // 배경색 설정
              ),
              child: const Row(
                children: [
                  Icon(Icons.search), // 검색 아이콘
                  Text(
                    '검색', // 검색창 텍스트
                    style: TextStyle(
                      fontSize: 15, // 텍스트 크기
                      color: Color(0xff838383), // 텍스트 색상
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit), // 수정 아이콘
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ReviewWriteView())); // ReviewWriteView로 이동
          },
        ),
      ],
    );
  }

  Widget _body() {
    // 피드 내용 위젯
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // 시작 위치에서 정렬
        children: List.generate( // 3개의 그룹 생성
          groupBox.length,
              (index) =>
              Expanded(
                child: Column(
                  children: List.generate(
                    groupBox[index].length,
                        (jndex) =>
                        GestureDetector(
                          onTap: () {
                            // Post 객체 생성
                            Post post = Post(
                              id: "post_$index$jndex",
                              // 적절한 id 생성
                              thumbnail: "https://example.com/thumbnail.jpg",
                              description: "This is a description",
                              likeCount: 100,
                              /* userInfo: IUser(
                                uid: "user_$index$jndex",
                                nickname: "User $index$jndex",
                                thumbnail: "https://example.com/user_thumbnail.jpg",
                              ), */
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                              deletedAt: null,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostWidget(post: post),
                              ),
                            );
                          },
                          child: Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .width * 0.33 * groupBox[index][jndex],
                            // 크기 설정. Get.width를 MediaQuery.of(context).size.width로 바꿨더니 간결성은 떨어지지만 오류가 사라졌다ㅠㅠㅠ
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white), // 경계선 설정
                              color: Colors.primaries[
                              Random().nextInt(
                                  Colors.primaries.length)], // 랜덤 색상 설정
                            ),
                          ),
                        ),
                  ).toList(),
                ),
              ),
        ).toList(),
      ),
    );
  }

  Widget _mapView(BuildContext context) {
    // 지도 화면 위젯
    return Scaffold(
      body: Stack(
        children: [
          MapView(
            onMapReady: (controller) {
              for (var place in viewModel.places) {
                final marker = NMarker(
                  id: place.id,
                  position: NLatLng(place.latitude, place.longitude),
                  caption: NOverlayCaption(text: place.name),
                );

                marker.setOnTapListener((overlay) {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        AlertDialog(
                          title: Text(place.name),
                          content: Text(place.description),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                  );
                });

                controller.addOverlay(marker);
              }
            },
          ), // 네이버 지도 위젯
          _buildBottomSheet(context), // 바텀 시트 위젯
        ],
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4, // 초기 크기 설정
      minChildSize: 0.2, // 최소 크기 설정
      maxChildSize: 0.8, // 최대 크기 설정
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: Colors.white, // 배경 색상 설정
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragUpdate: (details) {
                  // 스크롤 컨트롤러를 사용하여 드래그 동작을 업데이트
                  scrollController.position.moveTo(
                      scrollController.position.pixels - details.primaryDelta!);
                },
                child: Container(
                  width: double.infinity, // 너비를 화면 전체로 설정
                  padding: const EdgeInsets.all(16.0), // 패딩 설정
                  decoration: BoxDecoration(
                    color: Colors.white, // 배경 색상 설정
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.0)), // 상단 모서리 둥글게 설정
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12, // 그림자 색상 설정
                        offset: Offset(0, -1), // 그림자 위치 설정
                        blurRadius: 5.0, // 그림자 블러 크기 설정
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300], // 색상 설정
                          borderRadius: BorderRadius.circular(10), // 모서리 둥글게 설정
                        ),
                      ),
                      SizedBox(height: 10), // 간격 추가
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 20, // 예제용 아이템 수
                  itemBuilder: (BuildContext context, int index) {
                    // 예제 데이터
                    final store = {
                      'name': '가게 이름 $index',
                      'rating': '4.${index % 5}',
                      'reviews': '${index * 10} 리뷰',
                      'distance': '${index * 100}m',
                      'address': '경기 수원시 권선구 곡반정로 ${index * 10}',
                      'image': 'https://via.placeholder.com/150'
                    };

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8.0),
                          leading: Image.network(
                            store['image']!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            store['name']!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '평점: ${store['rating']} (${store['reviews']})',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 14),
                              ),
                              Text(
                                store['address']!,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12),
                              ),
                              Text(
                                store['distance']!,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}