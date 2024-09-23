import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/home_viewmodel.dart ';

// AttractionTabSection: 추천명소와 탭바를 포함한 섹션
class AttractionTabSection extends StatefulWidget {
  final TabController tabController;

  AttractionTabSection({required this.tabController});

  @override
  _AttractionTabSectionState createState() => _AttractionTabSectionState();
}

class _AttractionTabSectionState extends State<AttractionTabSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 추천명소 탭바 타이틀
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
        // TabBar 섹션: 카테고리 별로 콘텐츠를 분류
        Container(
          height: 48.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TabBar 설정
              TabBar(
                controller: widget.tabController,
                isScrollable: true,
                labelColor: Color(0xFF222222), // 선택된 탭의 텍스트 색상
                unselectedLabelColor: Color(0xFF999999), // 선택되지 않은 탭 텍스트 색상
                labelStyle: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                ),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: Color(0xFF1BB874), // 선택된 탭 밑줄 색상 (초록색)
                    width: 3.0,
                  ),
                  insets: EdgeInsets.symmetric(horizontal: 0.0), // 밑줄 길이
                ),
                tabs: [
                  Tab(text: '물속 체험'),
                  Tab(text: '크루즈 여행'),
                  Tab(text: '낚시'),
                  Tab(text: '전망대'),
                  Tab(text: '포토존'),
                ],
              ),
              // TabBar 구분선
              Container(
                height: 0.0,
                color: Color(0xFF999999),
                margin: EdgeInsets.symmetric(vertical: 0.0),
              ),
            ],
          ),
        ),
        // TabBarView: 각 탭에 해당하는 콘텐츠를 보여주는 영역
        Container(
          height: 200.0,
          child: TabBarView(
            controller: widget.tabController,
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
    );
  }

  // 각 탭의 콘텐츠를 생성하는 헬퍼 함수
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
