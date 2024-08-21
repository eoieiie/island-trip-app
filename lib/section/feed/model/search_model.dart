class SearchModel { // SearchModel 클래스 선언
  final String query; // 검색어 필드

  SearchModel(this.query); // 생성자

  Map<String, dynamic> toJson() {
    return {
      'query': query, // 검색어를 JSON으로 변환
    };
  }

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(json['query']); // JSON 데이터를 SearchModel 객체로 변환
  }
}
