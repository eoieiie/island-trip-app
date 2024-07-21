import 'package:flutter/material.dart';

class PhotoDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사진 상세 보기'),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            color: Colors.grey,
            child: Center(child: Text('사진 1')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('작성자 프로필'),
                    Text('울릉도, 한국'),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
                    Text('10'),
                    IconButton(icon: Icon(Icons.comment), onPressed: () {}),
                  ],
                ),
                IconButton(icon: Icon(Icons.bookmark_border), onPressed: () {}),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('@작성자프로필 여친과의 저녁을 방문했는데 사람 없이 한적했어요!'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Chip(label: Text('사람 없이 한적해요')),
                Chip(label: Text('연인과 가기 좋아요')),
                Chip(label: Text('사진 찍기 좋아요')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
