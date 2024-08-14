import 'package:flutter/material.dart'; // Flutter의 기본 UI 구성 요소를 가져옵니다.
import 'package:get/get.dart';
import 'package:project_island/section/feed/viewmodel/postcard_controller.dart';
import 'package:project_island/section/common/feed_my_page common/src/components/post_widget.dart';

class Postcard extends GetView<PostcardController> {
  const Postcard({Key? key}) : super(key: key);


  // 게시물 목록을 표시하는 위젯을 정의합니다.
  Widget _postList() {
    return Obx(() => Column(
      children: List.generate(controller.postList.length,
              (index) => PostWidget(post: controller.postList[index])).toList(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('탐색'),
        actions: [
          GestureDetector(
            onTap: () {}, // 탭 시 아무 동작 없음
            child: Padding(
              padding: const EdgeInsets.all(15.0), // 모든 방향으로 15 픽셀의 패딩 설정
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          _postList(), // 게시물 리스트 추가
        ],
      ),
    );
  }
}

