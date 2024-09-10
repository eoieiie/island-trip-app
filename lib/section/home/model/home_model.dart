class Magazine {
  final String title;
  final String description;
  final List<String> hashtags;
  final String thumbnail;
  final String? address; // 추가: 주소는 null이 될 수 있으므로 String?로 정의

  Magazine({
    required this.title,
    required this.description,
    required this.hashtags,
    required this.thumbnail,
    this.address, // 생성자에서 필드를 optional로 변경
  });
}
class Magazine1 {
  final String title;
  final String littletitle;
  final List<String> hashtags;
  final String content;

  Magazine1({
    required this.title,
    required this.littletitle,
    required this.hashtags,
    required this.content,
  });

  // JSON 데이터를 Magazine 객체로 변환하는 팩토리 메서드
  factory Magazine1.fromJson(Map<String, dynamic> json) {
    return Magazine1(
      title: json['_magazinetitle'] as String,
      littletitle: json['_magazinelittletitle'] as String,
      hashtags: List<String>.from(json['_magazinehashtags']),
      content: json['_magazinecontent'] as String,
    );
  }
}


class Content {
  final String title;
  final String description;
  final String category;

  Content({
    required this.title,
    required this.description,
    required this.category,
  });
}

class Store {
  final String name;
  final String category;
  final String location;
  final double rating;

  Store({
    required this.name,
    required this.category,
    required this.location,
    required this.rating,
  });
}

class IslandDetail {
  final String name;
  final String description;
  final List<Magazine> magazines;
  final List<String> reviews;
  final String? address; // 추가: 주소는 null이 될 수 있으므로 String?로 정의

  IslandDetail({
    required this.name,
    required this.description,
    required this.magazines,
    required this.reviews,
    this.address, // 생성자에서 필드를 optional로 변경
  });
}
