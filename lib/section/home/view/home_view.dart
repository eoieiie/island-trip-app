import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';  // flutter_svg 패키지 가져오기
import 'package:get/get.dart';
import 'package:project_island/section/home/view/island_detail_view.dart';
import 'package:project_island/section/home/viewmodel/home_viewmodel.dart';
import '../model/home_model.dart';
import '../repository/home_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeView extends StatelessWidget {
  final HomeViewModel viewModel = Get.put(HomeViewModel(Repository()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            'assets/images/isltrip-logo.svg',
            semanticsLabel: 'Isltrip Logo',
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // 그림자 제거
      ),
      body: Obx(() {
        if (viewModel.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return Container();
      }),
      bottomSheet: DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.8,
        builder: (context, scrollController) {
          return BottomSheetContent(
            viewModel: viewModel,
            scrollController: scrollController,
          );
        },
      ),
    );
  }
}

class BottomSheetContent extends StatelessWidget {
  final HomeViewModel viewModel;
  final ScrollController scrollController;

  BottomSheetContent({
    required this.viewModel,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Magazine',
              style: TextStyle(
                color: Color(0xFFC8C8C8),
                fontSize: 12,
                fontFamily: 'Lobster',
                fontWeight: FontWeight.w400,
                height: 0.11,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '지금 인기있는 놓칠 수 없는 섬',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.45 + 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: viewModel.magazines.length,
                itemBuilder: (context, index) {
                  final magazine = viewModel.magazines[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IslandDetailView()),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      margin: EdgeInsets.only(right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.width * 0.45,
                            child: MagazineCard(magazine: magazine),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            magazine.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.0),
                          Opacity(
                            opacity: 0.4,
                            child: Row(
                              children: [
                                Text(
                                  'by.',
                                  style: TextStyle(
                                    color: Color(0xFF999999),
                                    fontSize: 12,
                                    fontFamily: 'Lobster',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(width: 4.0),
                                Text(
                                  '아일트립',
                                  style: TextStyle(
                                    color: Color(0xFF999999),
                                    fontSize: 11,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 0.10,
                                  ),
                                ),
                                SizedBox(width: 4.0),
                                Text(
                                  '.',
                                  style: TextStyle(
                                    color: Color(0xFFC8C8C8),
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 0.11,
                                  ),
                                ),
                                SizedBox(width: 4.0),
                                Text(
                                  magazine.title,
                                  style: TextStyle(
                                    color: Color(0xFF999999),
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 0.10,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0), // 추가된 텍스트와의 간격을 줍니다.
            Opacity(
              opacity: 0.4,
              child: Text(
                'attraction',
                style: TextStyle(
                  color: Color(0xFFC8C8C8),
                  fontSize: 12,
                  fontFamily: 'Lobster',
                  fontWeight: FontWeight.w400,
                  height: 0.11,
                ),
              ),
            ),
            SizedBox(height: 26.0), // "attraction"과 "추천명소" 간의 간격
            Text(
              '추천명소',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 18,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                height: 0.09,
              ),
            ),
          ],
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: CachedNetworkImage(
        imageUrl: magazine.thumbnail,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
            Icon(Icons.image_not_supported),
      ),
    );
  }
}
