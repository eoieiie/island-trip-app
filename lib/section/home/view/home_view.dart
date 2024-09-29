import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:project_island/section/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/scheduler.dart'; // AppLifecycleListener 사용을 위해 필요
import '../model/home_model.dart';
import '../repository/home_repository.dart';
import '../viewmodel/magazine_viewmodel.dart';
import 'magazine_view.dart';
import 'attraction_tab_section.dart';
import 'island_detail_view.dart'; // IslandDetailView import 추가

// HomeView: 메인 홈 화면을 구성하는 클래스
class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final AppLifecycleListener _lifecycleListener;
  final HomeViewModel viewModel = Get.put(HomeViewModel(Repository())); // ViewModel 연결

  @override
  void initState() {
    super.initState();

    // AppLifecycleListener 설정
    _lifecycleListener = AppLifecycleListener(
      onShow: () {
        // 앱이 포그라운드로 돌아왔을 때 처리할 로직
        print('App is now visible (onShow)');
        viewModel.fetchData(); // 앱이 포그라운드로 돌아왔을 때 데이터를 다시 가져옴
      },
      onResume: () {
        print('App resumed (onResume)');
      },
      onHide: () {
        // 앱이 백그라운드로 갈 때 처리할 로직
        print('App is now hidden (onHide)');
      },
      onInactive: () {
        print('App is inactive (onInactive)');
      },
      onPause: () {
        // 앱이 일시 중지될 때 처리할 로직
        print('App paused (onPause)');
      },
      onDetach: () {
        print('App detached (onDetach)');
      },
      onRestart: () {
        // 앱이 재시작될 때 처리할 로직
        print('App restarted (onRestart)');
      },
      onStateChange: (AppLifecycleState state) {
        print('App lifecycle state: $state');
      },
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose(); // 생명주기 listener 제거
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // 데이터 로딩 중일 때 로딩 스피너를 표시
        if (viewModel.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        // 로딩이 끝나면 UI 구성
        return Stack(
          children: [
            // 기본 배경
            Positioned.fill(
              child: Container(
                color: Colors.white,
              ),
            ),
            // 매거진 섹션
            MagazineSection(viewModel: viewModel),
            // 로고 표시
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
            // 하단에서 올라오는 Draggable Scrollable Sheet (바텀 시트)
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

// MagazineSection: 매거진을 표시하는 섹션
class MagazineSection extends StatefulWidget {
  final HomeViewModel viewModel;

  MagazineSection({required this.viewModel});

  @override
  _MagazineSectionState createState() => _MagazineSectionState();
}

class _MagazineSectionState extends State<MagazineSection> {
  int currentPage = 0; // 현재 페이지 인덱스

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Stack(
        children: [
          // PageView로 매거진을 가로로 스크롤
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: MagazineListView(
              viewModel: widget.viewModel,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index; // 페이지 변경 시 인덱스 업데이트
                });
              },
            ),
          ),
          // 매거진 하단에 페이지 인디케이터 표시
          Positioned(
            bottom: 10.0,
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

// MagazineListView: PageView.builder를 사용하여 매거진 카드들을 수평 스크롤로 표시
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
      physics: ClampingScrollPhysics(),
      itemCount: viewModel.magazines.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        final magazine = viewModel.magazines[index];
        final magazineViewModel = Get.put(
            MagazineViewModel(magazine, Repository()),
            tag: magazine.title);

        return Obx(() {
          if (magazineViewModel.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          final matchingMagazine1 = magazineViewModel.jsonMagazines.firstWhere(
                (magazine1) => magazine1.islandtag.trim().toLowerCase() ==
                magazine.title.trim().toLowerCase(),
            orElse: () => Magazine1(
              title: 'No Title',
              littletitle: 'No Subtitle',
              hashtags: [],
              content: [],
              islandtag: 'No Island',
            ),
          );

          return GestureDetector(
            onTap: () {
              // IslandDetailView로 이동하도록 수정
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IslandDetailView(
                    islandName: magazine.title, // 섬 이름 전달
                  ),
                ),
              );
            },
            child: MagazineCard(
              magazine: magazine,
              magazine1: matchingMagazine1,
              isFirst: index == 0,
              isRounded: false,
            ),
          );
        });
      },
    );
  }
}

// MagazineCard: 매거진 데이터를 사용하여 카드 형태로 렌더링하는 위젯
class MagazineCard extends StatelessWidget {
  final Magazine magazine;
  final Magazine1? magazine1;
  final bool isFirst;
  final bool isRounded;

  const MagazineCard({
    required this.magazine,
    this.magazine1,
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
          // 매거진 썸네일 이미지 로드
          CachedNetworkImage(
            imageUrl: magazine.thumbnail,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => FutureBuilder<String>(
              future: Get.find<HomeViewModel>()
                  .repository
                  .getFallbackThumbnail(magazine.title),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                    color: Colors.white,
                    child: const Center(
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
          // 매거진 텍스트 정보
          if (magazine1 != null)
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
                    TextSpan(
                      text: magazine1!.title,
                      style: const TextStyle(
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
                      text: magazine1!.islandtag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
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

// IndicatorBar: 매거진 스크롤 시 하단에 표시되는 페이지 인디케이터
class IndicatorBar extends StatelessWidget {
  final int currentPage;
  final int itemCount;

  IndicatorBar({required this.currentPage, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0,
      margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(itemCount, (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            width: currentPage == index ? 16.0 : 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              color: currentPage == index ? Color(0xFF1BB874) : Color(0xFF999999),
              borderRadius: BorderRadius.circular(4.0),
            ),
          );
        }),
      ),
    );
  }
}

// BottomSheetContent: 하단에서 올라오는 바텀 시트 콘텐츠
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
    // TabBar의 탭 개수 설정 (5개)
    _tabController = TabController(length: 5, vsync: this);
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
          borderRadius: const BorderRadius.only(
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
            // 바텀 시트 내 타이틀
            const Text(
              'Isleland Chart',
              style: TextStyle(
                color: Color(0xFFC8C8C8),
                fontSize: 12,
                fontFamily: 'Lobster',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 4.0),
            const Column(
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
            // 섬 관련 매거진 카드 표시
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.45 + 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.viewModel.magazines.length,
                itemBuilder: (context, index) {
                  final magazine = widget.viewModel.magazines[index];
                  return Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        // IslandDetailView로 이동하도록 수정
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IslandDetailView(
                              islandName: magazine.title, // 섬 이름 전달
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.width * 0.45,
                            child: MagazineCard(
                              magazine: magazine,
                              magazine1: null,
                              isRounded: true,
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Text(
                            magazine.title,
                            style: const TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 13,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.bold,
                              height: 0.10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 4.0),
            // AttractionTabSection 호출
            AttractionTabSection(),
          ],
        ),
      ),
    );
  }
}
