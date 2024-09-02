// view/magazine_view.dart
/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repository/home_repository.dart';
import '../viewmodel/magazine_viewmodel.dart';

// MagazineView 클래스를 정의하는 StatelessWidget
class MagazineView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // GetX를 사용하여 MagazineViewModel을 초기화
    final viewModel = Get.put(MagazineViewModel(repository: Repository()));

    return Scaffold(
      appBar: AppBar(
        title: Text('울릉도 매거진'),
      ),
      // Obx를 사용하여 viewModel의 상태 변화를 감지하고 UI를 업데이트
      body: Obx(() {
        // 로딩 중일 때 로딩 인디케이터를 표시
        if (viewModel.magazines.isEmpty && viewModel.stores.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        // 로딩이 완료되면 콘텐츠를 표시
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목 섹션
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '갈매기의 고향 울릉도',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // 매거진 소개 섹션
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
              // 매거진 리스트 섹션
              _buildMagazineList(viewModel),
              SizedBox(height: 16.0),
              // 장소 보기 섹션 제목
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '매거진의 장소 보기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8.0),
              // 장소 그리드 섹션
              _buildStoreGrid(viewModel),
              SizedBox(height: 16.0),
            ],
          ),
        );
      }),
    );
  }

  // 매거진 리스트를 빌드하는 메서드
  Widget _buildMagazineList(MagazineViewModel viewModel) {
    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(() {
        return ListView.builder(
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
        );
      }),
    );
  }

  // 장소 그리드를 빌드하는 메서드
  Widget _buildStoreGrid(MagazineViewModel viewModel) {
    return Container(
      height: 400,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(() {
        return GridView.builder(
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
        );
      }),
    );
  }
}
