import 'package:flutter/material.dart';
import 'package:project_island/section/map/model/island_model.dart';
import 'package:project_island/section/map/viewmodel/homemap_list_controller.dart';

// 이미지 위젯
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
            // 이미지 로딩 실패 시 대체 이미지 표시
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

// 주소 표시 위젯
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

// 제목 표시 위젯
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

// 설명(평점, 영업 상태) 표시 위젯
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
              const Icon(Icons.star, color: Colors.yellow, size: 16), // 별 아이콘
              const SizedBox(width: 4), // 아이콘과 텍스트 사이 간격
              Text(
                rating.toString(),
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        if (rating != null && isOpenNow != null)
          const SizedBox(width: 8), // 평점과 영업 상태 사이 간격
        if (isOpenNow != null)
          Text(
            isOpenNow! ? '영업 중' : '영업 종료',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold, // 영업 상태 굵게 표시
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
        controller.toggleBookmark(item); // 북마크 토글 동작
        onUpdate(); // UI 업데이트
      },
    );
  }
}
