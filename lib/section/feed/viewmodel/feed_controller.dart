import 'package:get/get.dart'; // GetX 패키지 가져오기
import 'package:project_island/section/feed/model/post_model.dart'; // Post 모델 가져오기
import 'package:project_island/section/feed/repository/post_repository.dart'; // PostRepository 가져오기
//post의 model, repository 가져옴
class FeedController extends GetxController {
  RxList<Post> postList = <Post>[].obs; // 게시물 리스트를 RxList로 관리하여 UI에 자동 업데이트 반영

  @override
  void onInit() {
    super.onInit();
    _loadFeedList(); // 컨트롤러 초기화 시 피드 데이터 로드
  }

  void _loadFeedList() async {
    print("Loading feed list..."); // 로그 추가
    var feedList = await PostRepository.loadFeedList();


    if (feedList.isNotEmpty) {
      print("Feed list loaded: ${feedList.length} items"); // 데이터가 로드되었음을 확인하는 로그
      postList.addAll(feedList); // 가져온 피드 리스트를 postList에 추가
    } else {
      print("No items found in the feed list."); // 데이터가 비어 있음을 알리는 로그
    }
  }
}

/*  void _loadFeedList() async {
    var feedList = await PostRepository.loadFeedList();
    postList.addAll(feedList);
  }
}
*/