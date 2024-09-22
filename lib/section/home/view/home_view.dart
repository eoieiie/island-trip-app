import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:project_island/section/home/view/island_detail_view.dart';
import 'package:project_island/section/home/viewmodel/home_viewmodel.dart';
import '../model/home_model.dart';
import '../repository/home_repository.dart';
import '../viewmodel/magazine_viewmodel.dart';
import 'magazine_view.dart';

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
            Positioned.fill(
              child: Container(
                color: Colors.white,
              ),
            ),
            MagazineSection(viewModel: viewModel),
            Positioned(
              top: 30.0,
              left: 2.0,
              child: SvgPicture.asset(
                'assets/images/isltrip-logo.svg',
                width: 100.0,
                height: 50.0,
                fit: BoxFit.contain,
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.40,
              minChildSize: 0.40,
              maxChildSize: 1.0,
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

class MagazineSection extends StatefulWidget {
  final HomeViewModel viewModel;

  MagazineSection({required this.viewModel});

  @override
  _MagazineSectionState createState() => _MagazineSectionState();
}

class _MagazineSectionState extends State<MagazineSection> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Stack( // Stack을 사용하여 카드와 인디케이터를 겹쳐서 배치
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55, // 매거진 카드 높이 조정
            child: MagazineListView(
              viewModel: widget.viewModel,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
            ),
          ),
          Positioned(
            bottom: 10.0,  // 인디케이터가 카드 위에 올라오도록 위치 조정
            left: 0,
            right: 0,
            child: IndicatorBar(
              currentPage: currentPage,
              itemCount: widget.viewModel.magazines.length,
            ),
          ),
        ],
      ),
    );
  }
}

class MagazineListView extends StatelessWidget {
  final HomeViewModel viewModel;
  final Function(int) onPageChanged;

  MagazineListView({
    required this.viewModel,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      physics: ClampingScrollPhysics(), // 스와이프 시 딱딱 넘어가도록 설정
      itemCount: viewModel.magazines.length,
      onPageChanged: onPageChanged, // 페이지 변경 시 호출되는 콜백 함수
      itemBuilder: (context, index) {
        final magazine = viewModel.magazines[index];
        // MagazineViewModel에서 해당 magazine title에 맞는 데이터를 가져옴
        final magazineViewModel = Get.put(MagazineViewModel(magazine, Repository()), tag: magazine.title);

        return Obx(() {
          if (magazineViewModel.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          // 매칭된 magazine1 데이터를 가져옴
          final matchingMagazine1 = magazineViewModel.jsonMagazines.firstWhere(
                (magazine1) => magazine1.islandtag.trim().toLowerCase() == magazine.title.trim().toLowerCase(),
            orElse: () => Magazine1(  // 기본값을 반환
                title: 'No Title',
                littletitle: 'No Subtitle',
                hashtags: [],
                content: [],
                islandtag: 'No Island'
            ),
          );

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MagazineView(
                    islandName: magazine.title, magazine: magazine, // 섬 이름을 전달
                  ),
                ),
              );
            },
            child: MagazineCard(
              magazine: magazine,
              magazine1: matchingMagazine1, // matching된 데이터 전달
              isFirst: index == 0,
              isRounded: false, // 모서리를 둥글지 않게 설정
            ),
          );
        });
      },
    );
  }
}

class MagazineCard extends StatelessWidget {
  final Magazine magazine; // HomeViewModel에서 가져온 magazine
  final Magazine1? magazine1; // MagazineViewModel에서 가져온 json 매칭된 magazine1
  final bool isFirst;
  final bool isRounded;

  const MagazineCard({
    required this.magazine,
    this.magazine1, // optional로 magazine1 추가
    this.isFirst = false,
    this.isRounded = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: isRounded ? BorderRadius.circular(12.0) : BorderRadius.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: magazine.thumbnail,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => FutureBuilder<String>(
              future: Get.find<HomeViewModel>().repository.getFallbackThumbnail(magazine.title), // 대체 썸네일 호출
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        "사진이 없어요!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Image.network(snapshot.data!, fit: BoxFit.cover);
                }
              },
            ),
          ),
          if (magazine1 != null)  // magazine1이 null이 아닐 때만 텍스트 출력
            Positioned(
              bottom: 46.0,
              left: 20.0,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '[',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    // 매거진 타이틀을 magazine1에서 가져옴
                    TextSpan(
                      text: magazine1!.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    TextSpan(
                      text: ']\n',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    TextSpan(
                      // 매거진 섬 이름을 magazine1에서 가져옴
                      text: magazine1!.islandtag,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      // 매거진 소제목을 magazine1에서 가져옴
                      text: '\n${magazine1!.littletitle}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            ),
        ],
      ),
    );
  }
}

class IndicatorBar extends StatelessWidget {
  final int currentPage;
  final int itemCount;

  IndicatorBar({required this.currentPage, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.0,  // 인디케이터 높이 설정
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),  // 상하 여백 조정
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
        children: List.generate(itemCount, (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0), // 인디케이터 간 간격
            width: currentPage == index ? 16.0 : 8.0,  // 현재 페이지에 해당하는 인디케이터 크기
            height: 8.0,
            decoration: BoxDecoration(
              color: currentPage == index ? Color(0xFF1BB874) : Color(0xFF999999),  // 선택된/미선택된 색상
              borderRadius: BorderRadius.circular(4.0),  // 둥근 모서리
            ),
          );
        }),
      ),
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
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Container(
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
                          child: MagazineCard(
                            magazine: magazine,
                            magazine1: null, // 바텀시트 안에서는 json 데이터를 넘기지 않음
                            isRounded: true, // 모서리를 둥글게 유지
                          ),
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
            SizedBox(height: 4.0),
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
            Container(
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
