class Magazine {
  final String title;
  final String description;
  final List<String> hashtags;
  final String thumbnail;

  Magazine({
    required this.title,
    required this.description,
    required this.hashtags,
    required this.thumbnail, required address,
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
  final List<Store> stores;
  final List<Content> contents;

  IslandDetail({
    required this.name,
    required this.description,
    required this.magazines,
    required this.reviews,
    required this.stores,
    required this.contents,
  });
}
