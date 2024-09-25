import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart'; // 클립보드 사용을 위해 추가
import 'package:flutter_svg/flutter_svg.dart';
import '../repository/home_repository.dart';
import '../viewmodel/island_detail_viewmodel.dart';
import 'package:project_island/section/home/viewmodel/home_viewmodel.dart';
import 'magazine_view.dart'; // MagazineView 화면을 가져오기 위해 추가

// TabBar의 커스텀 인디케이터 클래스
class CustomWidthUnderlineTabIndicator extends Decoration {
  final double indicatorWidth;
  final BorderSide borderSide;

  const CustomWidthUnderlineTabIndicator({
    required this.borderSide,
    required this.indicatorWidth,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomWidthUnderlinePainter(this, onChanged);
  }
}

class _CustomWidthUnderlinePainter extends BoxPainter {
  final CustomWidthUnderlineTabIndicator decoration;

  _CustomWidthUnderlinePainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  @override
  void paint(
      Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final double indicatorWidth = decoration.indicatorWidth;
    final double left = rect.left + (rect.width - indicatorWidth) / 2;
    final double right = left + indicatorWidth;
    final double bottom = rect.bottom;

    final Paint paint = decoration.borderSide.toPaint();
    canvas.drawLine(Offset(left, bottom), Offset(right, bottom), paint);
  }
}

class IslandDetailView extends StatefulWidget {
  final String islandName; // 섬 이름을 받는 매개변수

  const IslandDetailView({super.key, required this.islandName});

  @override
  _IslandDetailViewState createState() => _IslandDetailViewState();
}

class _IslandDetailViewState extends State<IslandDetailView>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late IslandDetailViewModel viewModel;
  final HomeViewModel homeViewModel =
  Get.find<HomeViewModel>(); // HomeViewModel 인스턴스 추가
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 탭 수를 2로 변경
    _pageController.addListener(() {
      setState(() {});
    });

    // ViewModel 초기화 및 섬 정보 로드
    viewModel = Get.put(IslandDetailViewModel(Repository()));
    viewModel.fetchIslandDetails(widget.islandName); // 동적으로 섬 정보를 로드

    // 섬에 대한 매거진 데이터를 가져옵니다.
    homeViewModel.fetchMagazinesForIsland(widget.islandName);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 페이지 배경색을 흰색으로 설정
      body: Obx(() {
        if (viewModel.isLoading.value || homeViewModel.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (viewModel.errorMessage.isNotEmpty) {
          return Center(child: Text(viewModel.errorMessage.value));
        } else {
          int currentPage = _pageController.hasClients
              ? _pageController.page!.toInt()
              : 0;

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 사진 영역을 화면 상단에 배치
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4, // 화면 높이에 비례한 높이
                          color: Colors.white, // 배경을 흰색으로 설정
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: viewModel.islandImages.length,
                            itemBuilder: (context, index) {
                              final imageUrl = viewModel.islandImages[index];
                              return Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        // 인디케이터를 사진 내부 하단에 배치
                        Positioned(
                          bottom: 16.0, // 사진의 아래쪽에 위치
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                viewModel.islandImages.length,
                                    (index) {
                                  return AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    // 애니메이션 적용
                                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                                    width: currentPage == index ? 16.0 : 8.0,
                                    height: 8.0,
                                    decoration: BoxDecoration(
                                      color: currentPage == index
                                          ? Colors.green
                                          : Colors.grey.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(4.0), // 둥근 모서리 설정
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 섬 이름
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
                      child: Text(
                        viewModel.islandName1.value ?? '섬 이름',
                        // 섬 이름을 여기에 넣으세요
                        style: const TextStyle(
                          color: Color(0xFF222222),
                          fontSize: 20,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 0.08,
                        ),
                      ),
                    ),
                    // 탭바
                    TabBar(
                      controller: _tabController,
                      labelColor: Color(0xFF222222),
                      unselectedLabelColor: Color(0xFF999999),
                      labelStyle: const TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 13,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                        height: 0.12,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 13,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 0.12,
                      ),
                      // 커스텀 인디케이터 적용
                      indicator: CustomWidthUnderlineTabIndicator(
                        borderSide: BorderSide(color: Color(0xFF222222), width: 2.0),
                        indicatorWidth: MediaQuery.of(context).size.width / 2, // 절반 길이
                      ),
                      tabs: const [
                        Tab(text: '섬정보'),
                        Tab(text: '매거진'),
                      ],
                    ),
                    // 탭바 하단 화면
                    Container(
                      height: 500, // 적절한 높이로 조정
                      child: TabBarView(
                        controller: _tabController,
                        physics: NeverScrollableScrollPhysics(), // 스크롤 충돌 방지
                        children: [
                          // '섬정보' 탭 화면
                          SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '길찾기',
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(text: viewModel.islandAddress.value ?? '주소 없음'));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('주소가 복사되었습니다.')),
                                          );
                                        },
                                        icon: SvgPicture.asset(
                                          'assets/images/boksa.svg', // 복사 아이콘 이미지 경로
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.0),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/icon-pin-location-mono.svg', // 핀 아이콘 이미지 경로
                                        width: 24,
                                        height: 24,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        viewModel.islandAddress.value ?? '주소를 여기에 입력하세요', // 주소를 여기에 입력하세요
                                        style: const TextStyle(
                                          color: Color(0xFF999999),
                                          fontSize: 12,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                          height: 0.11,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.0),
                                  Text(
                                    viewModel.islandDescription.value ?? '여기에 섬에 대한 상세 정보를 입력하세요.',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // '매거진' 탭 화면
                          SingleChildScrollView(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Obx(() {
                                  if (viewModel.islandMagazines.isEmpty) {
                                    return Text(
                                      '매거진 내용이 없습니다.',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey[700],
                                      ),
                                    );
                                  } else {
                                    return Column(
                                      children: viewModel.islandMagazines.map((magazine) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => MagazineView(
                                                  magazine: magazine,
                                                  islandName: '',
                                                ),
                                              ),
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(16.0),
                                            child: FutureBuilder<String>(
                                              future: magazine.thumbnail.isNotEmpty
                                                  ? Future.value(magazine.thumbnail)
                                                  : Get.find<HomeViewModel>().repository.getFallbackThumbnail(magazine.title),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return Container(
                                                    height: 200.0,
                                                    child: const Center(
                                                      child: CircularProgressIndicator(),
                                                    ),
                                                  );
                                                } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                                                  return Container(
                                                    height: 200.0,
                                                    color: Colors.grey,
                                                    child: const Center(
                                                      child: Text("사진이 없습니다"),
                                                    ),
                                                  );
                                                } else {
                                                  return Container(
                                                    height: 200.0,
                                                    child: Stack(
                                                      fit: StackFit.expand,
                                                      children: [
                                                        Image.network(
                                                          snapshot.data!,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        // 이미지 위에 텍스트 오버레이
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                              begin: Alignment.topCenter,
                                                              end: Alignment.bottomCenter,
                                                              colors: [
                                                                Colors.transparent,
                                                                Colors.black.withOpacity(0.7),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          left: 16.0,
                                                          bottom: 16.0,
                                                          right: 16.0,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.location_pin,
                                                                    color: Colors.white,
                                                                    size: 16,
                                                                  ),
                                                                  SizedBox(width: 4.0),
                                                                  Text(
                                                                    magazine.title,
                                                                    style: const TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 14.0,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(height: 5.0),
                                                              Text(
                                                                '매거진 #1',
                                                                style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 20.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 28.0, // 상단에 위치
                left: -9.0, // 왼쪽에 위치
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // 뒤로가기 기능
                  },
                  child: SvgPicture.asset(
                    'assets/images/backbutton.svg', // 뒤로가기 버튼 이미지 경로
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
