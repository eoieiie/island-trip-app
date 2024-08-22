import 'package:flutter/material.dart';
import 'package:project_island/section/my_page/viewmodel/saved_controller.dart';
import 'package:project_island/section/my_page/model/saved_model.dart';

class SavedListView extends StatelessWidget {
  final SavedController controller;
  final String selectedCategory;

  SavedListView({
    required this.controller,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final items = controller.getSavedItems(selectedCategory); // 선택된 카테고리에 해당하는 아이템들 가져오기

    return ListView.builder(
      // 리스트뷰 빌더 사용
      itemCount: items.length, // 아이템 개수
      itemBuilder: (context, index) {
        final item = items[index]; // 현재 아이템 가져오기
        return Column(
          children: [
            SavedListItem(item: item, controller: controller), // 리스트 아이템 생성
            if (index != items.length - 1) // 마지막 아이템이 아니면 Divider 추가
        Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5), // 패딩 설정
        child: Divider(
          color: Colors.grey[100], // 연한 회색 선
          thickness: 1, // 선 두께
          height: 1, // 선 높이
        ),),

          ],
        );
      },
    );
  }
}

class SavedListItem extends StatelessWidget {
  final SavedItem item;
  final SavedController controller;

  SavedListItem({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ItemImage(imageUrl: item.imageUrl), // 이미지를 ItemImage 위젯으로 분리
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ItemAddress(address: item.address), // 주소를 ItemAddress 위젯으로 분리
          ItemTitle(title: item.title), // 제목을 ItemTitle 위젯으로 분리
          ItemDescription(description: item.description), // 설명을 ItemDescription 위젯으로 분리
        ],
      ),
      trailing: BookmarkButton(item: item, controller: controller), // 북마크 버튼을 BookmarkButton 위젯으로 분리
    );
  }
}

class ItemImage extends StatelessWidget {
  final String imageUrl;

  ItemImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70, // 원하는 가로 크기 설정
      height: 70, // 원하는 세로 크기 설정
      child: AspectRatio(
        aspectRatio: 1 / 1, // 1:1 비율로 설정
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0), // 이미지 둥근 모서리
          child: Image.network(imageUrl, fit: BoxFit.cover), // 비율에 맞춘 이미지
        ),
      ),
    );
  }
}



class ItemAddress extends StatelessWidget {
  final String address;

  ItemAddress({required this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_pin, color: Colors.grey, size: 14), // 위치 아이콘
        SizedBox(width: 4), // 간격
        Text(address, style: TextStyle(fontSize: 14 ,color: Colors.grey[400])), // 주소
      ],
    );
  }
}

class ItemTitle extends StatelessWidget {
  final String title;

  ItemTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize:20, fontWeight: FontWeight.bold), // 굵은 글씨 스타일 적용
    );
  }
}

class ItemDescription extends StatelessWidget {
  final String description;

  ItemDescription({required this.description});

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: TextStyle(fontSize: 14, color: Colors.grey), // 설명 텍스트 스타일 설정
    );
  }
}

class BookmarkButton extends StatelessWidget {
  final SavedItem item;
  final SavedController controller;

  BookmarkButton({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        item.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: item.isBookmarked ? Colors.yellow : Colors.grey,
      ), // 북마크 아이콘
      onPressed: () {
        controller.toggleBookmark(item); // 북마크 토글 기능
      },
    );
  }
}
