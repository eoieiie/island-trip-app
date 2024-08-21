import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller 클래스 정의
class SearchFocusController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController; // TabController 선언

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this); // TabController 초기화 (탭 개수 3개)
  }

  // 검색을 처리하는 메서드
  void search(String query) {
    // 검색 로직 추가
    print('Searching for $query');
  }

  @override
  void onClose() {
    tabController.dispose(); // Controller가 종료될 때 TabController를 해제
    super.onClose();
  }
}
