import 'package:flutter/material.dart';
import 'package:project_island/section/feed/viewmodel/auth_controller.dart';
import 'package:project_island/section/my_page/model/user_model.dart';
import 'package:get/get.dart';

class MypageController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  Rx<IUser> targetUser = IUser().obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void setTargetUser() {
    var uid = Get.parameters['targetUid'];
    if (uid == null) {
      targetUser(AuthController.to.user.value);
    } else {
      //TODO 상대 uid 로 users collection 조회
    }
  }

  void _loadData() {
    setTargetUser();

    // 포스트 리스트 로드
    // 사용자 정보 로드
  }
}
