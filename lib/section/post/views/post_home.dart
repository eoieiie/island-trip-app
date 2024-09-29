import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/post.dart';
import '../viewmodels/post_viewmodel.dart';
import 'postview.dart';
import 'post_page.dart';

class PostHomePage extends StatefulWidget {
  @override
  _PostHomePageState createState() => _PostHomePageState();
}

class _PostHomePageState extends State<PostHomePage> {
  final PostViewModel postViewModel = PostViewModel();

  // 새로고침 함수 추가
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
          '커뮤니티',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
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
              stream: postViewModel.getPosts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var posts = snapshot.data!;
                  if (posts.isEmpty) {
                    return const Center(child: Text('게시글이 없습니다.'));
                  } else {
                    return ListView.separated(
                      itemCount: posts.length,
                      separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 17), // Divider 양쪽 여백
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
                              overflow: TextOverflow.ellipsis, // 긴 제목에 말줄임표 적용
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
                                    const Icon(Icons.person, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        post.author,
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
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
                  // 에러 발생 시 에러 메시지 표시
                  return const Center(child: Text('오류가 발생했습니다.'));
                } else {
                  // 데이터가 아직 로드되지 않았을 때 빈 컨테이너 반환
                  return Container();
                }
              },
            ),
          ),
          // 로딩 인디케이터
          StreamBuilder<List<Post>>(
            stream: postViewModel.getPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // 데이터 로딩 중일 때 로딩 표시
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
                return const SizedBox.shrink(); // 로딩 중이 아닐 때는 아무것도 표시하지 않음
              }
            },
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 45, // 버튼의 가로 크기
        height: 45, // 버튼의 세로 크기
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF3CCB7F),
          elevation: 3,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostPage()),
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18), // 둥글기 설정
          ),
        ),
      ),

    );
  }
}