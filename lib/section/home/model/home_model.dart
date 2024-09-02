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
