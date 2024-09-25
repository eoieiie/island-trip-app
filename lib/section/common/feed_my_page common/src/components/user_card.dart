import 'package:flutter/material.dart';
import 'package:project_island/section/common/feed_my_page common/src/components/avatar_widget.dart';

class UserCard extends StatelessWidget {
  final String userId;
  final String description;

  const UserCard({
    super.key, // 'Key? key'를 super 매개변수로 변환하여 코드 간결화
    required this.userId,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 150,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.black12,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 15,
            right: 15,
            top: 0,
            bottom: 0,
            child: Column(
              children: [
                const SizedBox(height: 10),
                const AvatarWidget( // 'AvatarWidget'에 const 추가하여 성능 최적화
                  type: AvatarType.type2,
                  thumbPath:
                  'https://thumbs.dreamstime.com/b/photo-portrait-cheerful-cool-swag-trend-trendy-guy-leaving-his-feedback-social-media-network-using-smart-phone-photo-145377495.jpg',
                  size: 80,
                ),
                const SizedBox(height: 10),
                Text(
                  userId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Follow'),
                ),
              ],
            ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.close,
                size: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
