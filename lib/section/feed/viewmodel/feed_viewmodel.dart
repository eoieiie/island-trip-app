// import 'package:project_island/section/feed/view/post_viewmodel.dart';


import 'package:project_island/section/feed/model/post_model.dart';
import 'package:project_island/section/feed/repository/post_repository.dart';
import 'package:get/get.dart';

class FeedController extends GetxController {
  RxList<Post> postList = <Post>[].obs;
  @override
  void onInit() {
    super.onInit();
    _loadFeedList();
  }

  void _loadFeedList() async {
    var feedList = await PostRepository.loadFeedList();
    postList.addAll(feedList);
  }
}
