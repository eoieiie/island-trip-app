import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.transparent,
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
              colorFilter: ColorFilter.mode(
                selectedIndex == 0 ? const Color(0xFF1BB874) : const Color(0xFFC8C8C8),
                BlendMode.srcIn,
              ),
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/icon_calendar.svg',
              colorFilter: ColorFilter.mode(
                selectedIndex == 1 ? const Color(0xFF1BB874) : const Color(0xFFC8C8C8),
                BlendMode.srcIn,
              ),
            ),
            label: '일정',
          ),
          const BottomNavigationBarItem(
            icon: SizedBox.shrink(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/icon-stack-up-square-mono.svg',
              colorFilter: ColorFilter.mode(
                selectedIndex == 3 ? const Color(0xFF1BB874) : const Color(0xFFC8C8C8),
                BlendMode.srcIn,
              ),
            ),
            label: '저장',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/icon-user-mono.svg',
              colorFilter: ColorFilter.mode(
                selectedIndex == 4 ? const Color(0xFF1BB874) : const Color(0xFFC8C8C8),
                BlendMode.srcIn,
              ),
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
