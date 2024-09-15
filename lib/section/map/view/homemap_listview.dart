import 'package:flutter/material.dart';
import 'package:project_island/section/map/viewmodel/homemap_list_controller.dart';
import 'package:project_island/section/map/model/island_model.dart';

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

// ItemImage 위젯 정의
class ItemImage extends StatelessWidget {
  final String imageUrl;

  const ItemImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // 이미지 로드에 실패하면 로컬 이미지로 대체
            return Image.asset(
              'assets/images/No_photo_available.webp',
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}

// 주소를 표시하는 위젯
class ItemAddress extends StatelessWidget {
  final String address;

  const ItemAddress({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_pin, color: Colors.grey, size: 14),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            address,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// 장소 이름을 표시하는 위젯
class ItemTitle extends StatelessWidget {
  final String title;

  const ItemTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      overflow: TextOverflow.ellipsis,
    );
  }
}

// 설명(평점과 영업 상태)을 표시하는 위젯
class ItemDescription extends StatelessWidget {
  final double? rating;
  final bool? isOpenNow;

  const ItemDescription({super.key, required this.rating, required this.isOpenNow});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (rating != null)
          Row(
            children: [
              const Icon(Icons.star, color: Colors.yellow, size: 16), // 별표 아이콘
              const SizedBox(width: 4), // 아이콘과 텍스트 사이의 간격
              Text(
                rating.toString(),
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        if (rating != null && isOpenNow != null)
          const SizedBox(width: 8), // 평점과 영업 상태 사이의 간격
        if (isOpenNow != null)
          Text(
            isOpenNow! ? '영업 중' : '영업 종료',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold, // 영업 상태 텍스트 굵게 표시
              color: isOpenNow! ? Colors.green : Colors.red,
            ),
          ),
      ],
    );
  }
}

// 북마크 버튼 위젯
class BookmarkButton extends StatelessWidget {
  final IslandModel item;
  final HomemapListController controller;
  final VoidCallback onUpdate;

  const BookmarkButton({
    super.key,
    required this.item,
    required this.controller,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        item.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: item.isBookmarked ? Colors.yellow : Colors.grey,
      ),
      onPressed: () {
        controller.toggleBookmark(item);
        onUpdate();
      },
    );
  }
}