import 'package:flutter/material.dart';
import 'package:project_island/section/map/viewmodel/homemap_list_controller.dart';
import 'package:project_island/section/map/model/island_model.dart';
import 'package:project_island/section/map/widget/homemap_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
//

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
      controller: scrollController, // // DraggableScrollableSheet에서 전달된 ScrollController 사용
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
              onTap: () async {
                String url = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(item.name)}&query_place_id=${item.placeId}';
                Uri uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('해당 장소의 정보를 열 수 없습니다.')),
                  );
                }
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
