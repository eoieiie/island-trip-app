import 'package:flutter/material.dart';
import 'package:project_island/section/saved/viewmodel/saved_controller.dart';
import 'package:project_island/section/saved/model/saved_model.dart';

class SavedListView extends StatelessWidget {
  final List<SavedItem> items;
  final SavedController controller;

  const SavedListView({
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
              leading: ItemImage(imageUrl: item.imageUrl),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ItemAddress(address: item.address),
                  ItemTitle(title: item.title),
                  ItemDescription(
                    rating: item.rating,
                    isOpenNow: item.isOpenNow,
                  ),
                ],
              ),
              trailing: BookmarkButton(
                item: item,
                controller: controller,
                onUpdate: () => controller.toggleBookmark(item),
              ),
              onTap: () {
                // 상세 페이지 이동 로직 추가 가능
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

// ItemAddress 위젯 정의
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

// ItemTitle 위젯 정의
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

// ItemDescription 위젯 정의
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
              const Icon(Icons.star, color: Colors.yellow, size: 16),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        if (rating != null && isOpenNow != null)
          const SizedBox(width: 8),
        if (isOpenNow != null)
          Text(
            isOpenNow! ? '영업 중' : '영업 종료',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isOpenNow! ? Colors.green : Colors.red,
            ),
          ),
      ],
    );
  }
}

// 북마크 버튼 위젯 정의
class BookmarkButton extends StatelessWidget {
  final SavedItem item;
  final SavedController controller;
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
