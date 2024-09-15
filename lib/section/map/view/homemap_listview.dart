import 'package:flutter/material.dart';
import 'package:project_island/section/map/viewmodel/homemap_list_controller.dart';
import 'package:project_island/section/map/model/island_model.dart';
import 'package:project_island/section/map/widget/homemap_widgets.dart'; // 위젯 파일 import

class HomemapListView extends StatelessWidget {
  final List<IslandModel> items;
  final HomemapListController controller;

  const HomemapListView({
    super.key,
    required this.items,
    required this.controller,
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
              leading: ItemImage(imageUrl: item.imageUrl), // 분리된 ItemImage 위젯 사용
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ItemAddress(address: item.address), // 분리된 ItemAddress 위젯 사용
                  ItemTitle(title: item.title), // 분리된 ItemTitle 위젯 사용
                  ItemDescription(
                    rating: item.rating,
                    isOpenNow: item.isOpenNow,
                  ), // 분리된 ItemDescription 위젯 사용
                ],
              ),
              trailing: BookmarkButton(
                item: item,
                controller: controller,
                onUpdate: () => controller.toggleBookmark(item),
              ), // 분리된 BookmarkButton 위젯 사용
              onTap: () {
                // 상세 페이지로 이동하는 로직을 구현할 수 있음
                // 예시: Get.to(() => PlaceDetailPage(place: item));
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
