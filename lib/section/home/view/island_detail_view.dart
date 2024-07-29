import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/island_detail_viewmodel.dart';
import 'magazine_view.dart';
import 'place_detail_view.dart';

class IslandDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IslandDetailViewModel()..fetchIslandDetails('울릉도'),
      child: Scaffold(
        appBar: AppBar(
          title: Text('울릉도'),
        ),
        body: Consumer<IslandDetailViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.island == null) {
              return Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  _buildCategorySelector(viewModel),
                  SizedBox(height: 16.0),
                  _buildStoreGrid(viewModel),
                  SizedBox(height: 16.0),
                ],
              ),
            );
          },
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

  Widget _buildCategorySelector(IslandDetailViewModel viewModel) {
    final categories = ['전체', '한식', '중식', '일식', '양식', '카페'];
    return Container(
      height: 50, // 버튼이 적당히 보이도록 높이를 설정합니다.
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
          final isSaved = viewModel.savedStores.contains(store.name);

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
            ),
          );
        },
      ),
    );
  }

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
