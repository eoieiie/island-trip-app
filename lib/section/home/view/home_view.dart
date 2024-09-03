import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:project_island/section/home/view/island_detail_view.dart';
import 'package:project_island/section/home/viewmodel/home_viewmodel.dart';
import '../model/home_model.dart';
import '../repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:project_island/section/home/view/island_detail_view.dart';
import 'package:project_island/section/home/viewmodel/home_viewmodel.dart';
import '../model/home_model.dart';
import '../repository/home_repository.dart';

class HomeView extends StatelessWidget {
  final HomeViewModel viewModel = Get.put(HomeViewModel(Repository()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (viewModel.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return Stack(
          children: [
            // 상단 절반을 차지하는 MagazineListView
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: MagazineListView(viewModel: viewModel),
            ),
            // 바텀 시트 영역
            // 왼쪽 상단에 로고 추가
            Positioned(
              top: 30.0,
              left: 2.0,
              child: SvgPicture.asset(
                'assets/images/isltrip-logo.svg',
                width: 100.0, // 로고의 너비를 설정합니다.
                height: 50.0, // 로고의 높이를 설정합니다.
                fit: BoxFit.contain, // 로고를 어떻게 맞출지 설정합니다.
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.47,
              minChildSize: 0.47,
              maxChildSize: 1.0, // 화면 끝까지 올라갈 수 있도록 설정
              builder: (context, scrollController) {
                return BottomSheetContent(
                  viewModel: viewModel,
                  scrollController: scrollController,
                );
              },
            ),
          ],
        );
      }),
    );
  }
}

class MagazineListView extends StatelessWidget {
  final HomeViewModel viewModel;

  MagazineListView({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: viewModel.magazines.length,
      itemBuilder: (context, index) {
        final magazine = viewModel.magazines[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IslandDetailView(
                  islandName: magazine.title, // 섬 이름을 전달
                ),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width, // 가로 길이 화면과 딱 맞게 설정
            margin: EdgeInsets.only(right: 0), // 카드 사이의 간격 없앰
            child: MagazineCard(magazine: magazine, isFirst: index == 0),
          ),
        );
      },
    );
  }
}


class BottomSheetContent extends StatefulWidget {
  final HomeViewModel viewModel;
  final ScrollController scrollController;

  BottomSheetContent({
    required this.viewModel,
    required this.scrollController,
  });

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this); // 탭의 개수 설정
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.0,
                      height: 4.0,
                      margin: EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFC8C8C8),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ),
                  Text(
                    'Isleland Chart',
                    style: TextStyle(
                      color: Color(0xFFC8C8C8),
                      fontSize: 12,
                      fontFamily: 'Lobster',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '지금 인기있는',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '놓칠 수 없는 섬',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  // 매거진 카드 목록
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.45 + 100, // 카드 하단 공간 추가
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.viewModel.magazines.length,
                      itemBuilder: (context, index) {
                        final magazine = widget.viewModel.magazines[index];
                        return Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height: MediaQuery.of(context).size.width * 0.45, // 정사각형 비율
                                child: MagazineCard(magazine: magazine),
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                magazine.title, // 섬 이름
                                style: TextStyle(
                                  color: Color(0xFF999999),
                                  fontSize: 11,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  height: 0.10,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 0),
                  // attraction 및 추천명소 텍스트
                  Text(
                    'attraction',
                    style: TextStyle(
                      color: Color(0xFFC8C8C8),
                      fontSize: 12,
                      fontFamily: 'Lobster',
                      fontWeight: FontWeight.w400,
                      height: 0.11,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    '추천명소',
                    style: TextStyle(
                      color: Color(0xFF222222),
                      fontSize: 18,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      height: 2,
                    ),
                  ),
                  SizedBox(height: 0.0),
                  // 탭 바
                  Container(
                    height: 48.0, // 탭 바의 높이
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          labelColor: Color(0xFF222222), // 선택된 탭의 텍스트 색상
                          unselectedLabelColor: Color(0xFF999999), // 선택되지 않은 탭의 텍스트 색상
                          labelStyle: TextStyle(
                            fontFamily: 'Pretendard', // 선택된 탭의 폰트
                            fontWeight: FontWeight.w600, // 선택된 탭의 폰트 굵기
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontFamily: 'Pretendard', // 선택되지 않은 탭의 폰트
                            fontWeight: FontWeight.w400, // 선택되지 않은 탭의 폰트 굵기
                          ),
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              color: Color(0xFF1BB874), // 초록색 밑줄
                              width: 3.0, // 밑줄 두께
                            ),
                            insets: EdgeInsets.symmetric(horizontal: 0.0), // 밑줄의 가로 길이
                          ),
                          tabs: [
                            Tab(text: '물속 체험'),
                            Tab(text: '크루즈 여행'),
                            Tab(text: '낚시'),
                            Tab(text: '전망대'),
                            Tab(text: '포토존'),
                          ],
                        ),
                        Container(
                          height: 0.0, // 구분선의 높이 설정
                          color: Color(0xFF999999), // 구분선 색
                          margin: EdgeInsets.symmetric(vertical: 0.0),
                        ),
                      ],
                    ),
                  ),
                  // TabBarView 섹션
                  SizedBox(
                    height: 200.0, // 원하는 높이로 조정
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTabContent('물속 체험'),
                        _buildTabContent('크루즈 여행'),
                        _buildTabContent('낚시'),
                        _buildTabContent('전망대'),
                        _buildTabContent('포토존'),
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

  Widget _buildTabContent(String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
          color: Color(0xFF222222),
          fontSize: 16,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class MagazineCard extends StatelessWidget {
  final Magazine magazine;
  final bool isFirst;

  const MagazineCard({required this.magazine, this.isFirst = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 클릭 시 IslandDetailView로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IslandDetailView(
              islandName: magazine.title, // 섬 이름을 전달
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0), // 모서리 둥글게 설정
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: magazine.thumbnail,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Container(
                color: Colors.white, // 흰색 배경
                child: Center(
                  child: Text(
                    "사진이 없어요!", // 썸네일 없는 경우 대체 텍스트
                    style: TextStyle(
                      color: Colors.black, // 텍스트 색상
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            if (isFirst) // 첫 번째 카드에만 텍스트 추가
              Positioned(
                bottom: 21.0,
                left: 16.0,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '[',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 20,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      TextSpan(
                        text: '내 마음을 물들이다.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      TextSpan(
                        text: ']\n',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 20,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      TextSpan(
                        text: '거문도',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '\n맑은 바다와 울창한 숲이 어우러진 거문도,\n자연의 숨결을 느껴보세요',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w300,
                          height: 1.5, // 줄 높이 조절
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

