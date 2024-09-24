import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final String author; // 작성자 이름 추가
  final String authorId; // 작성자 ID 추가
  final DateTime timestamp;

  Post({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.author,
    required this.authorId,
    required this.timestamp,
  });

  // Firestore 문서에서 데이터를 가져와서 Post 객체로 변환
  factory Post.fromDocument(Map<String, dynamic> doc, String id) {
    return Post(
      id: id,
      title: doc['title'],
      content: doc['content'],
      imageUrl: doc['imageUrl'],
      author: doc['author'] ?? 'Unknown', // 작성자 이름
      authorId: doc['authorId'] ?? '', // 작성자 ID
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
    );
  }
}
