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
}// json 매거진 내용 gpt야 이걸 수정해도 돼
class Magazine1 {
  final String title;
  final String littletitle;
  final List<String> hashtags;
  final List<MagazineContent> content;

  Magazine1({
    required this.title,
    required this.littletitle,
    required this.hashtags,
    required this.content,
  });

  factory Magazine1.fromJson(Map<String, dynamic> json) {
    return Magazine1(
      title: json['_magazinetitle'] as String? ?? 'No Title', // null일 경우 기본값 사용
      littletitle: json['_magazinelittletitle'] as String? ?? 'No Subtitle', // null일 경우 기본값 사용
      hashtags: json['_magazinehashtags'] != null
          ? List<String>.from(json['_magazinehashtags'])
          : [], // null일 경우 빈 리스트 사용
      content: json['_magazinecontent'] != null
          ? (json['_magazinecontent'] as List)
          .map((item) => MagazineContent.fromJson(item))
          .toList()
          : [], // null일 경우 빈 리스트 사용
    );
  }
}


class MagazineContent {
  final String title;
  final String content;
  final String CI;

  MagazineContent({
    required this.title,
    required this.content,
    required this.CI,
  });

  factory MagazineContent.fromJson(Map<String, dynamic> json) {
    return MagazineContent(
      title: json['title'] as String? ?? 'No Title', // null일 경우 기본값 사용
      content: json['content'] as String? ?? 'No Content', // null일 경우 기본값 사용
      CI: json['CI'] as String? ?? '', // null일 경우 빈 문자열 사용
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
