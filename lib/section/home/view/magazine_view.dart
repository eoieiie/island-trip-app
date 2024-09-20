import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/home_model.dart';
import '../viewmodel/magazine_viewmodel.dart';
import '../repository/home_repository.dart'; // Repository import

class MagazineView extends StatelessWidget {
  final Magazine magazine; // Magazine 객체를 받는 매개변수
  final PageController _pageController = PageController(); // PageController 추가
  final RxInt currentPage = 0.obs; // 현재 페이지를 추적하는 변수 추가

  MagazineView({required this.magazine});

  @override
  Widget build(BuildContext context) {
    // Repository를 인스턴스화하고 ViewModel을 초기화
    final MagazineViewModel viewModel = Get.put(
      MagazineViewModel(magazine, Repository()),
      tag: magazine.title,  // 섬 이름으로 태그를 추가하여 구분
      permanent: false,  // 항상 새로운 인스턴스 생성
    );

    return Scaffold(
      body: Obx(() {
        if (viewModel.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (viewModel.errorMessage.isNotEmpty) {
          return Center(child: Text(viewModel.errorMessage.value));
        } else if (viewModel.jsonMagazines.isEmpty || viewModel.islandImages.isEmpty) {
          return Center(child: Text('No data available for this island.')); // 데이터가 없을 경우 메시지 출력
        } else {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 이미지 슬라이더 섹션
                    if (viewModel.islandImages.isNotEmpty)
                      Container(
                        height: MediaQuery.of(context).size.width, // 화면의 가로 길이와 동일하게 설정하여 정사각형 비율로 만듦
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: viewModel.islandImages.length,
                              onPageChanged: (index) {
                                currentPage.value = index; // 현재 페이지 인덱스 업데이트
                              },
                              itemBuilder: (context, index) {
                                final imageUrl = viewModel.islandImages[index];
                                return Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.width, // 정사각형 비율로 설정
                                );
                              },
                            ),
                            // 이미지 인디케이터
                            Positioned(
                              bottom: 10.0, // 사진의 아래쪽에 위치
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Obx(() => Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(viewModel.islandImages.length, (index) {
                                      return AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                                        width: currentPage.value == index ? 16.0 : 8.0,
                                        height: 8.0,
                                        decoration: BoxDecoration(
                                          color: currentPage.value == index ? Color(0xFF1BB874) : Colors.grey.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(4.0),
                                        ),
                                      );
                                    })),
                                ),
                              ),
                            ),
                            // 상단 뒤로 가기 버튼
                            Positioned(
                              top: 40.0,
                              left: 16.0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(); // 뒤로 가기 기능
                                },
                                child: Icon(
                                  Icons.arrow_back_ios_new, // 새로운 화살표 아이콘 사용
                                  color: Colors.white, // 아이콘 색상 흰색
                                  size: 24.0, // 아이콘 크기 조정
                                ),
                              ),
                            ),
                            // 상단 오른쪽 메뉴 버튼
                            Positioned(
                              top: 40.0,
                              right: 16.0,
                              child: GestureDetector(
                                onTap: () {
                                  // 메뉴 버튼 기능 추가
                                },
                                child: Icon(
                                  Icons.more_vert, // 메뉴 아이콘
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 16.0),

                    // 섬 이름과 주소 표시 섹션
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 섬 이름 표시
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Color(0xFF1BB874), // 색상 스타일 지정
                              borderRadius: BorderRadius.circular(12.0), // 모서리 둥글게 설정
                            ),
                            child: Text(
                              magazine.title, // API로 받아온 섬 이름
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                                height: 1.5, // 텍스트 높이 조정
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0), // 섬 이름과 주소 사이 간격

                          // 주소 표시
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0), // 주소를 더 아래로 이동하여 높이 조정
                              child: Text(
                                magazine.address ?? '주소 없음', // API로 받아온 주소
                                style: TextStyle(
                                  color: Color(0xFF999999), // 텍스트 색상
                                  fontSize: 12,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  height: 0.11, // 줄 간격 설정
                                ),
                                overflow: TextOverflow.ellipsis, // 주소가 길 경우 말줄임표 처리
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0), // 섬 이름과 주소 사이 간격

                    // 제목 표시 섹션
                    if (viewModel.jsonMagazines.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          viewModel.jsonMagazines.first.title, // JSON에서 가져온 매거진 제목
                          style: TextStyle(
                            color: Color(0xFF222222),
                            fontSize: 20,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                    SizedBox(height: 20.0), // 제목과 부제목 사이 간격

                    // 부제목 표시 섹션
                    if (viewModel.jsonMagazines.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          viewModel.jsonMagazines.first.littletitle, // JSON에서 가져온 매거진 부제목
                          style: TextStyle(
                            color: Color(0xFF222222),
                            fontSize: 13,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w300,
                            height: 0.12,
                          ),
                        ),
                      ),

                    // 해시태그 표시 섹션
                    if (viewModel.jsonMagazines.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: viewModel.jsonMagazines.first.hashtags.map((hashtag) {
                            return Chip(
                              label: Text(hashtag),
                              backgroundColor: Colors.green.shade100,
                            );
                          }).toList(),
                        ),
                      ),

                    // 여러 개의 섹션을 표시
                    if (viewModel.jsonMagazines.isNotEmpty)
                      ...viewModel.jsonMagazines.first.content.map((section) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                section.title, // 섹션 제목
                                style: TextStyle(
                                  color: Color(0xFF222222),
                                  fontSize: 18,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                section.content, // 섹션 내용
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 13,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              if (section.CI.isNotEmpty)
                                Image.network(
                                  '이미지 API 호출 URL/${section.CI}', // CI로 이미지 불러오기
                                  fit: BoxFit.cover,
                                ),
                              SizedBox(height: 20.0),
                            ],
                          ),
                        );
                      }).toList(),

                    // 경계선 섹션
                    const SizedBox(height: 16), // 경계선 위의 간격
                    Container(
                      width: double.infinity,
                      height: 8,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 8,
                            decoration: BoxDecoration(color: Color(0xFF999999).withOpacity(0.1)), // 투명한 경계선 색상 설정
                          ),
                        ],
                      ),
                    ),

                    // "Recommend" 텍스트 표시 섹션
                    const SizedBox(height: 16), // 경계선과 "Recommend" 텍스트 사이 간격
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Recommend',
                        style: TextStyle(
                          color: Color(0xFFC8C8C8),
                          fontSize: 12,
                          fontFamily: 'Lobster',
                          fontWeight: FontWeight.w400,
                          height: 0.11,
                        ),
                      ),
                    ),

                    // "이런 매거진은 어떠세요?" 텍스트 표시 섹션
                    const SizedBox(height: 25), // "Recommend"와 "이런 매거진은 어떠세요?" 사이 간격
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "이런 매거진은 어떠세요?",
                        style: TextStyle(
                          color: Color(0xFF222222),
                          fontSize: 18,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          height: 0.09,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
