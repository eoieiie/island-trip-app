import 'package:flutter/material.dart';

class ItemImage extends StatelessWidget {
  final String? imageUrl;

  const ItemImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(imageUrl!, fit: BoxFit.cover)
            : Container(
          color: Colors.grey[300],
          child: Center(
            child: Text(
              '사진이 등록되지 않았습니다',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ),
        ),
      ),
    );
  }
}







