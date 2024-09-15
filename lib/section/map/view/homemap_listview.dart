import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_island/section/map/model/island_model.dart';
import 'package:project_island/section/map/viewmodel/homemap_list_controller.dart';
import 'package:project_island/section/map/widget/homemap_widgets.dart'; // 위젯 파일 import

class HomemapListView extends StatelessWidget {
  final List<IslandModel> items;
  final HomemapListController controller;
  final String selectedCategory;

  const HomemapListView({
    super.key,
    required this.items,
    required this.controller,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Column(
          children: [
            ListTile(
              leading: ItemImage(imageUrl: item.imageUrl), // 이미지 위젯 사용
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ItemAddress(address: item.address), // 주소 위젯 사용
                  ItemTitle(title: item.title), // 제목 위젯 사용
                  ItemDescription(
                    rating: item.rating,
                    isOpenNow: item.isOpenNow,
                  ), // 설명 위젯 사용
                ],
              ),
              trailing: BookmarkButton(
                item: item,
                controller: controller,
                onUpdate: () => controller.toggleBookmark(item), // 북마크 토글 동작
              ),
              onTap: () {
                // 상세 페이지 이동 코드 (필요 시 구현)
              },
            ),
            if (index != items.length - 1)
              Divider(
                color: Colors.grey[200],
                thickness: 1,
                height: 1,
              ),
          ],
        );
      },
    );
  }
}
