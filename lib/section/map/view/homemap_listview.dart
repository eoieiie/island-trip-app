import 'package:flutter/material.dart';
import 'package:project_island/section/map/viewmodel/homemap_list_controller.dart';
import 'package:project_island/section/map/model/island_model.dart';
import 'package:project_island/section/map/widget/homemap_widgets.dart';

class HomemapListView extends StatelessWidget {
  final List<IslandModel> items;
  final HomemapListController controller;
  final ScrollController scrollController; // ScrollController 추가

  const HomemapListView({
    super.key,
    required this.items,
    required this.controller,
    required this.scrollController, // ScrollController 추가
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController, // ScrollController 사용
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Column(
          children: [
            ListTile(
              leading: ItemImage(imageUrl: item.imageUrl), // ItemImage 위젯 사용
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ItemAddress(address: item.address), // ItemAddress 위젯 사용
                  ItemTitle(title: item.title), // ItemTitle 위젯 사용
                  ItemDescription(
                    rating: item.rating,
                    isOpenNow: item.isOpenNow,
                  ), // ItemDescription 위젯 사용
                ],
              ),
              trailing: BookmarkButton(
                item: item,
                controller: controller,
                onUpdate: () => controller.toggleBookmark(item),
              ),
              onTap: () {
                // 상세 페이지로 이동하는 로직 구현
                // Get.to(() => PlaceDetailPage(place: item));
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
