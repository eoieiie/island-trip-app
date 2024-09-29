import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/post.dart';
import '../viewmodels/post_viewmodel.dart';
import 'postview.dart'; // 게시글 상세 페이지로 이동하기 위해 필요

class MyPostsPage extends StatefulWidget {
  @override
  _MyPostsPageState createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  final PostViewModel postViewModel = PostViewModel();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> _refreshPosts() async {
    setState(() {
      // 상태를 갱신하여 StreamBuilder가 다시 빌드되도록 함
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '내 게시글',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            color: const Color(0xFF3CCB7F),
            onRefresh: _refreshPosts,
            child: StreamBuilder<List<Post>>(
              stream: postViewModel.getMyPosts(currentUserId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var posts = snapshot.data!;
                  if (posts.isEmpty) {
                    return const Center(child: Text('내 게시글이 없습니다.'));
                  } else {
                    return ListView.separated(
                      itemCount: posts.length,
                      separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                          height: 0.5,
                        ),
                      ),
                      itemBuilder: (context, index) {
                        var post = posts[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(5),
                            title: Text(
                              post.title,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 3),
                                Text(
                                  post.content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                                ),
                                const SizedBox(height: 7),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                    const SizedBox(width: 3),
                                    Text(
                                      DateFormat('yyyy-MM-dd HH:mm').format(post.timestamp),
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              // 게시글 상세 페이지로 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDetailPage(postId: post.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                } else if (snapshot.hasError) {
                  return const Center(child: Text('오류가 발생했습니다.'));
                } else {
                  return Container();
                }
              },
            ),
          ),
          StreamBuilder<List<Post>>(
            stream: postViewModel.getMyPosts(currentUserId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return IgnorePointer(
                  ignoring: true,
                  child: Container(
                    color: Colors.white.withOpacity(0.7),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.green[300],
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
