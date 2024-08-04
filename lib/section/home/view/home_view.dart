// view/home_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_island/section/home/view/island_detail_view.dart';
import 'package:project_island/section/home/viewmodel/home_viewmodel.dart';
import '../model/home_model.dart';
import '../repository/home_repository.dart';

// 홈 화면을 표시하는 StatelessWidget 클래스
class HomeView extends StatelessWidget {
  // GetX를 사용하여 HomeViewModel을 초기화
  final HomeViewModel viewModel = Get.put(HomeViewModel(Repository()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('홈'),
      ),
      // Obx를 사용하여 viewModel의 상태 변화를 감지하고 UI를 업데이트
      body: Obx(() {
        // 로딩 중일 때 로딩 인디케이터를 표시
        if (viewModel.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // 로딩이 완료되면 콘텐츠를 표시
        return Column(
          children: [
            // 상단에 있는 버튼 섹션
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // 버튼 클릭 시 IslandDetailView로 이동
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
            // 나머지 콘텐츠를 포함하는 확장 가능한 섹션
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 첫 번째 섹션 - 매거진
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
                          // 매거진 리스트가 비어있지 않으면 매거진 카드들을 표시
                          if (viewModel.magazines.isNotEmpty)
                            ...viewModel.magazines.map((magazine) => MagazineCard(magazine: magazine)).toList(),
                          SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                    // 두 번째 섹션 - 스노쿨링 - 스쿠버다이빙 명소
                    Section(
                      title: '스노쿨링 - 스쿠버다이빙 명소',
                      contents: viewModel.contents,
                    ),
                    // 세 번째 섹션 - 낚시
                    Section(
                      title: '낚시',
                      contents: viewModel.fishingContents,
                    ),
                    // 네 번째 섹션 - 전망대
                    Section(
                      title: '전망대',
                      contents: viewModel.viewpointContents,
                    ),
                    // 다섯 번째 섹션 - 해수욕장
                    Section(
                      title: '해수욕장',
                      contents: viewModel.beachContents,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// 매거진 카드를 표시하는 StatelessWidget 클래스
class MagazineCard extends StatelessWidget {
  final Magazine magazine;

  MagazineCard({required this.magazine});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    magazine.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    magazine.description,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    magazine.hashtags.join(' '),
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
    );
  }
}

// 각 섹션을 표시하는 StatelessWidget 클래스
class Section extends StatelessWidget {
  final String title;
  final List<Content> contents;

  Section({required this.title, required this.contents});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Container(
            height: 300,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: contents.length,
              itemBuilder: (context, index) {
                final content = contents[index];
                return AspectRatio(
                  aspectRatio: 1 / 2,
                  child: Card(
                    child: Center(child: Text(content.title)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
