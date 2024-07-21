import 'package:flutter/material.dart';

class CommentBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
        itemCount: 10,  // Example item count
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(),
            title: Text('작성자 $index'),
            subtitle: Text('댓글 내용'),
            trailing: Icon(Icons.favorite_border),
          );
        },
      ),
    );
  }
}
