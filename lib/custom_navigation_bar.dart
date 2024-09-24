import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.transparent, // 그림자를 투명으로 설정
            blurRadius: 0,
          ),
        ],
      ),
      child: BottomNavigationBar(
        selectedFontSize: 0,
        unselectedFontSize: 0,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/icon-home-mono.svg',
              color: selectedIndex == 0 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/icon_calendar.svg',
              color: selectedIndex == 1 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
            ),
            label: '일정',
          ),
          BottomNavigationBarItem(
            icon: Container(), // 가운데에 플로팅 액션 버튼이 들어가므로 빈 공간
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/icon-stack-up-square-mono.svg',
              color: selectedIndex == 3 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
            ),
            label: '저장',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/icon-user-mono.svg',
              color: selectedIndex == 4 ? Color(0xFF1BB874) : Color(0xFFC8C8C8),
            ),
            label: '마이페이지',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
