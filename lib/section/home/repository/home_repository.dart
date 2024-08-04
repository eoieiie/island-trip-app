import '../model/home_model.dart';

class Repository {
  // 더미 데이터 - 매거진 목록
  List<Magazine> fetchMagazines() {
    return [
      Magazine(
        title: '갈매기 까까, 울릉도',
        description: '사진 울릉도 고슴도치길 226-11',
        hashtags: ['#가성비', '#스쿠버다이빙', '#탁트인바다'],
        thumbnail: '',
      ),
      Magazine(
        title: '울릉도 여행의 모든 것',
        description: '울릉도의 숨은 명소들을 소개합니다.',
        hashtags: ['#여행', '#힐링', '#명소'],
        thumbnail: '',
      ),
    ];
  }

  // 더미 데이터 - 콘텐츠 목록
  List<Content> fetchContents() {
    return List.generate(20,
            (index) => Content(title: '스노쿨링 콘텐츠 $index', description: '스노쿨링 설명 $index', category: '스노쿨링'));
  }

  // 더미 데이터 - 낚시 콘텐츠 목록
  List<Content> fetchFishingContents() {
    return List.generate(20,
            (index) => Content(title: '낚시 콘텐츠 $index', description: '낚시 설명 $index', category: '낚시'));
  }

  // 더미 데이터 - 전망대 콘텐츠 목록
  List<Content> fetchViewpointContents() {
    return List.generate(20,
            (index) => Content(title: '전망대 콘텐츠 $index', description: '전망대 설명 $index', category: '전망대'));
  }

  // 더미 데이터 - 해수욕장 콘텐츠 목록
  List<Content> fetchBeachContents() {
    return List.generate(20,
            (index) => Content(title: '해수욕장 콘텐츠 $index', description: '해수욕장 설명 $index', category: '해수욕장'));
  }

  // 더미 데이터 - 특정 섬에 대한 세부 정보
  IslandDetail fetchIslandDetails(String islandName) {
    if (islandName == '울릉도') {
      return IslandDetail(
        name: '울릉도',
        description: '울릉도는 아름다운 자연과 다양한 액티비티를 즐길 수 있는 섬입니다.',
        magazines: fetchMagazines(),
        reviews: List.generate(10, (index) => '울릉도 후기 $index'),
        stores: [
          Store(name: '울릉도 한식 맛집 1', category: '한식', location: '울릉도 1', rating: 4.5),
          Store(name: '울릉도 중식 맛집 2', category: '중식', location: '울릉도 2', rating: 4.7),
          Store(name: '울릉도 일식 맛집 3', category: '일식', location: '울릉도 3', rating: 4.6),
          Store(name: '울릉도 양식 맛집 4', category: '양식', location: '울릉도 4', rating: 4.8),
          Store(name: '울릉도 카페 맛집 5', category: '카페', location: '울릉도 5', rating: 4.9),
          Store(name: '울릉도 한식 맛집 6', category: '한식', location: '울릉도 6', rating: 4.3),
          Store(name: '울릉도 중식 맛집 7', category: '중식', location: '울릉도 7', rating: 4.4),
          Store(name: '울릉도 일식 맛집 8', category: '일식', location: '울릉도 8', rating: 4.6),
          Store(name: '울릉도 양식 맛집 9', category: '양식', location: '울릉도 9', rating: 4.8),
          Store(name: '울릉도 카페 맛집 10', category: '카페', location: '울릉도 10', rating: 4.9),
        ],
        contents: fetchContents(),
      );
    } else {
      // 다른 섬 데이터 추가 가능
      return IslandDetail(
        name: islandName,
        description: '$islandName는 아직 데이터가 준비되지 않았습니다.',
        magazines: [],
        reviews: [],
        stores: [],
        contents: [],
      );
    }
  }

  // 카테고리별로 음식점 필터링
  List<Store> filterStoresByCategory(List<Store> stores, String category) {
    if (category == '전체') {
      return stores;
    }
    return stores.where((store) => store.category == category).toList();
  }
}
