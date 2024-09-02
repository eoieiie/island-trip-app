import 'package:flutter/material.dart';
import 'package:project_island/section/saved/viewmodel/saved_controller.dart';
import 'package:project_island/section/saved/model/saved_model.dart';

class SavedListView extends StatelessWidget {
  final List<SavedItem> items;
  final SavedController controller;

  const SavedListView({
    super.key, // 'key'를 super parameter로 변경
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
                  ItemAddress(address: item.address), // 주소 위젯
                  ItemTitle(title: item.title), // 장소 이름 위젯
                  ItemDescription(description: item.phone.isNotEmpty ? item.phone : item.website), // 설명 위젯: 전화번호 없으면 웹사이트
                ],
              ),
              trailing: BookmarkButton(
                item: item,
                controller: controller,
                onUpdate: () => controller.toggleBookmark(item),
              ),
              onTap: () {
                // 상세 페이지로 이동하는 로직
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

// 주소를 표시하는 위젯
class ItemAddress extends StatelessWidget {
  final String address;

  const ItemAddress({super.key, required this.address}); // 'key'를 super parameter로 변경

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_pin, color: Colors.grey, size: 14), // const 사용
        const SizedBox(width: 4), // SizedBox 사용
        Expanded(
          child: Text(
            address,
            style: const TextStyle(fontSize: 14, color: Colors.grey), // 주소 텍스트 스타일, const 사용
            overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 경우 생략 부호로 표시
          ),
        ),
      ],
    );
  }
}

// 장소 이름을 표시하는 위젯
class ItemTitle extends StatelessWidget {
  final String title;

  const ItemTitle({super.key, required this.title}); // 'key'를 super parameter로 변경

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // 장소 이름 텍스트 스타일, const 사용
      overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 경우 생략 부호로 표시
    );
  }
}

// 설명(전화번호 또는 웹사이트)을 표시하는 위젯
class ItemDescription extends StatelessWidget {
  final String description;

  const ItemDescription({super.key, required this.description}); // 'key'를 super parameter로 변경

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: const TextStyle(fontSize: 14, color: Colors.grey), // 설명 텍스트 스타일, const 사용
      overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 경우 생략 부호로 표시
    );
  }
}

// 이미지 표시 위젯
class ItemImage extends StatelessWidget {
  final String imageUrl;

  const ItemImage({super.key, required this.imageUrl}); // 'key'를 super parameter로 변경

  @override
  Widget build(BuildContext context) {
    return SizedBox( // Container 대신 SizedBox 사용
      width: 70,
      height: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}

// 북마크 버튼 위젯
class BookmarkButton extends StatelessWidget {
  final SavedItem item;
  final SavedController controller;
  final VoidCallback onUpdate;

  const BookmarkButton({
    super.key, // 'key'를 super parameter로 변경
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
