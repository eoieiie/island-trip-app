import 'package:get/get.dart'; // GetX 패키지 가져오기
import 'package:project_island/section/feed/model/post_model.dart'; // Post 모델 가져오기
import 'package:project_island/section/feed/repository/post_repository.dart'; // PostRepository 가져오기

class PostcardController extends GetxController { // 이름을 일치시킴
  RxList<Post> postList = <Post>[].obs; // 게시물 리스트를 RxList로 관리하여 UI에 자동 업데이트 반영

  @override
  void onInit() {
    super.onInit();
    _loadFeedList(); // 컨트롤러 초기화 시 피드 데이터 로드
  }

  void _loadFeedList() async {
    var feedList = await PostRepository.loadFeedList();
    postList.addAll(feedList);
  }
}
