import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repository/home_repository.dart';
import '../viewmodel/magazine_viewmodel.dart';

class MagazineView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MagazineViewModel(repository: Repository())
        ..fetchMagazines()
        ..fetchStores(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('울릉도 매거진'),
        ),
        body: Consumer<MagazineViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '갈매기의 고향 울릉도',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150.0, // 높이를 줄임
                    color: Colors.grey[300],
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '갈매기 까까, 울릉도',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '사진 울릉도 고슴도치길 226-11\n# 가성비 # 스쿠버다이빙 # 탁트인 바다 # ~~~',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildMagazineList(context, viewModel),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '매거진의 장소 보기',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  _buildStoreGrid(context, viewModel),
                  SizedBox(height: 16.0),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMagazineList(BuildContext context, MagazineViewModel viewModel) {
    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.magazines.length,
        itemBuilder: (context, index) {
          final magazine = viewModel.magazines[index];
          return Container(
            width: 160,
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            color: Colors.grey[400],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        magazine.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.0),
                      Text(magazine.description),
                      SizedBox(height: 4.0),
                      Text(magazine.hashtags.join(' ')),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStoreGrid(BuildContext context, MagazineViewModel viewModel) {
    return Container(
      height: 400,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: viewModel.stores.length,
        itemBuilder: (context, index) {
          final store = viewModel.stores[index];
          return Container(
            color: Colors.grey[300],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
