/* class Feed {
  final String id;
  final String userId;
  final String content;
  final String imageUrl;
  final DateTime createdAt;

  Feed({
    required this.id,
    required this.userId,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      id: json['id'],
      userId: json['userId'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

 */
