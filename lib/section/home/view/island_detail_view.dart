// view/island_detail_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/island_detail_viewmodel.dart';
import 'magazine_view.dart';
import 'place_detail_view.dart';

// 울릉도 상세 화면을 표시하는 StatelessWidget 클래스
class IslandDetailView extends StatelessWidget {
  // GetX를 사용하여 IslandDetailViewModel을 초기화
  final IslandDetailViewModel viewModel = Get.put(IslandDetailViewModel());

  @override
  Widget build(BuildContext context) {
    // 특정 섬의 상세 정보를 가져오기
    viewModel.fetchIslandDetails('울릉도');

    return Scaffold(
      appBar: AppBar(
        title: Text('울릉도'),
      ),
      // Obx를 사용하여 viewModel의 상태 변화를 감지하고 UI를 업데이트
      body: Obx(() {
        // 로딩 중일 때 로딩 인디케이터를 표시
        if (viewModel.island == null) {
          return Center(child: CircularProgressIndicator());
        }

        // 로딩이 완료되면 콘텐츠를 표시
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 첫 번째 섹션 - 울릉도 관련 매거진
              _buildSection(
                context,
                title: '울릉도 관련 매거진(눌러봐)',
                child: Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: viewModel.island?.magazines.length ?? 0,
                    itemBuilder: (context, index) {
                      final magazine = viewModel.island!.magazines[index];
                      return GestureDetector(
                        onTap: () {
                          // 매거진 클릭 시 MagazineView로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MagazineView()),
                          );
                        },
                        child: Container(
                          width: 160,
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          color: Colors.grey[300],
                          child: Center(child: Text(magazine.title)),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              // 두 번째 섹션 - 울릉도 찐 후기
              _buildSection(
                context,
                title: '울릉도 찐 후기',
                child: Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: viewModel.island?.reviews.length ?? 0,
                    itemBuilder: (context, index) {
                      final review = viewModel.island!.reviews[index];
                      return Container(
                        width: 160,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        color: Colors.grey[300],
                        child: Center(child: Text(review)),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              // 세 번째 섹션 - 울릉도 맛집
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
              SizedBox(height: 8.0),
              // 카테고리 선택 섹션
              _buildCategorySelector(viewModel),
              SizedBox(height: 16.0),
              // 맛집 리스트 섹션
              _buildStoreGrid(viewModel),
              SizedBox(height: 16.0),
            ],
          ),
        );
      }),
    );
  }

  // 각 섹션을 빌드하는 메서드
  Widget _buildSection(BuildContext context, {required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          child,
        ],
      ),
    );
  }

  // 카테고리 선택 위젯을 빌드하는 메서드
  Widget _buildCategorySelector(IslandDetailViewModel viewModel) {
    final categories = ['전체', '한식', '중식', '일식', '양식', '카페'];
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == viewModel.selectedCategory;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                viewModel.setSelectedCategory(category);
              },
            ),
          );
        },
      ),
    );
  }

  // 맛집 리스트를 그리드로 빌드하는 메서드
  Widget _buildStoreGrid(IslandDetailViewModel viewModel) {
    return Container(
      height: 400,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        scrollDirection: Axis.vertical,
        itemCount: viewModel.filteredStores.length,
        itemBuilder: (context, index) {
          final store = viewModel.filteredStores[index];
          return GestureDetector(
            onTap: () {
              // 맛집 클릭 시 PlaceDetailView로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlaceDetailView()),
              );
            },
            child: Obx(() {
              final isSaved = viewModel.savedStores.contains(store.name);
              return Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text('위치: ${store.location}'),
                    SizedBox(height: 4.0),
                    Text('별점: ${store.rating}'),
                    Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isSaved) {
                            viewModel.removeSavedStore(store.name);
                          } else {
                            viewModel.addSavedStore(store.name);
                          }
                        },
                        child: Text(isSaved ? '저장됨' : '저장'),
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }

  // 전체보기 버튼 클릭 시 표시할 전체 화면 다이얼로그
  void _showFullScreenDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Center(
            child: Text('$title 내용'),
          ),
        );
      },
    );
  }
}
