import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_island/section/home/view/island_detail_view.dart';
import 'package:project_island/section/home/viewmodel/home_viewmodel.dart';
import 'package:project_island/section/home/model/home_model.dart';

import '../repository/home_repository.dart';
class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(Repository()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('홈'),
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
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
          },
        ),
      ),
    );
  }
}

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