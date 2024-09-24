import 'package:flutter/material.dart';
import '../viewmodels/post_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart'; // flutter_svg 패키지 임포트

class PostDetailPage extends StatefulWidget {
  final String postId; // 선택한 게시글의 ID

  PostDetailPage({required this.postId});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final PostViewModel postViewModel = PostViewModel();
  TextEditingController _commentController = TextEditingController();
  FocusNode _commentFocusNode = FocusNode(); // FocusNode 추가
  Map<String, dynamic>? postData;

  // 새로고침 함수 추가
  Future<void> _refreshPostData() async {
    await _loadPostData();
    setState(() {
      // 상태를 갱신하여 화면을 다시 빌드
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPostData();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose(); // FocusNode 해제
    super.dispose();
  }

  // 데이터를 가져오는 함수
  Future<void> _loadPostData() async {
    var post = await postViewModel.getPostDetail(widget.postId);
    setState(() {
      postData = post;
    });
  }

  // 댓글 입력 필드 디자인 개선
  InputDecoration _commentInputDecoration() {
    return InputDecoration(
      hintText: ' 댓글을 입력하세요',
      hintStyle: TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 부모 컨텍스트 캡처
    final parentContext = context;

    return Scaffold(
      appBar: AppBar(
        // AppBar 설정 동일
        backgroundColor: Colors.white, // AppBar 배경색 흰색
        centerTitle: true, // AppBar 제목 가운데 정렬
        elevation: 0, // 그림자 제거 (필요에 따라 조절)
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // 아이콘 배경색 흰색
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context); // 뒤로 가기
              },
            ),
          ),
        ),
        title: Text(
          '게시글 상세',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 22,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (postData != null &&
              FirebaseAuth.instance.currentUser?.uid == postData!['authorId'])
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {
                // 포커스 해제하여 키보드 숨기기
                _commentFocusNode.unfocus();
                // 바텀 시트 표시
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SafeArea(
                      child: Wrap(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('삭제'),
                            onTap: () async {
                              Navigator.of(context).pop(); // 바텀 시트 닫기
                              // 확인 대화상자 표시
                              bool? confirmDelete = await showDialog(
                                context: parentContext, // 부모 컨텍스트 사용
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      '정말 삭제하시겠습니까?',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('네',
                                            style: TextStyle(
                                                fontSize: 13, color: Colors.black)),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                      TextButton(
                                        child: Text('아니오',
                                            style: TextStyle(
                                                fontSize: 13, color: Colors.black)),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (confirmDelete == true) {
                                // 게시글 삭제
                                await postViewModel.deletePost(widget.postId);
                                // 현재 페이지를 닫고 게시글 목록으로 이동
                                Navigator.of(parentContext).pop(); // PostDetailPage 닫기
                              }
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.close),
                            title: Text('닫기'),
                            onTap: () {
                              Navigator.of(context).pop(); // 바텀 시트 닫기
                              // 포커스 해제하여 키보드 숨기기
                              _commentFocusNode.unfocus();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ).whenComplete(() {
                  // 바텀 시트가 닫힌 후에 포커스 해제
                  _commentFocusNode.unfocus();
                });
              },
            ),
        ],
      ),
      body: postData == null
          ? Center(child: CircularProgressIndicator()) // 데이터가 로드될 때까지 로딩 표시
          : Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              color: Color(0xFF3CCB7F),
              onRefresh: _refreshPostData,
              child: ListView(
                children: [
                  // 게시글 내용 표시
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                      children: [
                        Text(
                          postData!['title'], // 게시글 제목
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis, // 긴 제목에 말줄임표 적용
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.person, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                postData!['author'], // 작성자 이름 표시
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis, // 긴 작성자 이름에 말줄임표 적용
                              ),
                            ),
                            SizedBox(width: 16),
                            Icon(Icons.access_time, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(
                              DateFormat('yyyy-MM-dd HH:mm')
                                  .format(postData!['timestamp'].toDate()), // 날짜 표시
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Divider(
                          thickness: 1,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 20),
                        Text(
                          postData!['content'], // 게시글 내용
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Divider(
                          thickness: 1,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                  // 댓글 리스트 위에 '댓글' 텍스트 추가
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Text(
                      '댓글',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // 댓글 리스트
                  StreamBuilder(
                    stream: postViewModel.getComments(widget.postId), // 댓글 가져오기
                    builder:
                        (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // 댓글 로딩 중일 때 로딩 표시
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        // 에러 발생 시 에러 메시지 표시
                        return Center(child: Text('댓글을 불러오는 중 오류가 발생했습니다.'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        // 댓글이 없을 때 메시지 표시
                        return Center(child: Text('댓글이 없습니다.'));
                      } else {
                        var comments = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            var comment = comments[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 2),
                              child: Card(
                                color: Color(0xFFE6F9EF),
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment['comment'],
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      SizedBox(height: 12), // 댓글과 작성자 사이의 간격 추가
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.person,
                                              size: 12, color: Colors.grey),
                                          SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              comment['author'], // 댓글 작성자 이름 표시
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.grey),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Icon(Icons.access_time,
                                              size: 12, color: Colors.grey),
                                          SizedBox(width: 4),
                                          Text(
                                            DateFormat('yyyy-MM-dd HH:mm')
                                                .format(comment['timestamp'].toDate()),
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: _buildDeleteCommentButton(
                                      comment, widget.postId),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          // 댓글 입력 필드
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          cursorColor: Color(0xFF6699FF), // 커서 색상
                          selectionColor: Color(0xFFBBDDFF), // 선택된 텍스트 배경색
                          selectionHandleColor: Color(0xFF6699FF), // 선택 핸들 색상
                        ),
                      ),
                      child: TextField(
                        controller: _commentController,
                        focusNode: _commentFocusNode, // FocusNode 지정
                        cursorColor: Color(0xFF6699FF),
                        decoration: _commentInputDecoration(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/send_Button_Active.svg',
                      width: 30,
                      height: 30,
                    ),
                    onPressed: () async {
                      if (_commentController.text.trim().isNotEmpty) {
                        // 키보드 내리기
                        _commentFocusNode.unfocus();

                        await postViewModel.addComment(widget.postId,
                            _commentController.text.trim());
                        _commentController.clear();
                        // 새로고침
                        _refreshPostData();
                      } else {
                        // 입력 값이 없을 때 사용자에게 알림
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('댓글을 입력하세요')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  // 댓글 삭제 버튼 빌드 (기존과 동일)
  Widget _buildDeleteCommentButton(
      Map<String, dynamic> comment, String postId) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.uid == comment['authorId']) {
      // 현재 사용자가 댓글 작성자인 경우 삭제 버튼 표시
      return IconButton(
        icon: Icon(Icons.more_vert), // 세 개의 점 아이콘
        onPressed: () {
          // 포커스 해제하여 키보드 숨기기
          _commentFocusNode.unfocus();
          // 바텀 시트 표시
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SafeArea(
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('삭제'),
                      onTap: () async {
                        Navigator.of(context).pop(); // 바텀 시트 닫기
                        // 확인 대화상자 표시
                        bool? confirmDelete = await showDialog(
                          context: context, // 현재 컨텍스트 사용
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                '정말 삭제하시겠습니까?',
                                style: TextStyle(fontSize: 18),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('네',
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black)),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                                TextButton(
                                  child: Text('아니오',
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black)),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        if (confirmDelete == true) {
                          // 댓글 삭제
                          await postViewModel.deleteComment(postId, comment['id']);
                          // 새로고침
                          _refreshPostData();
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.close),
                      title: Text('닫기'),
                      onTap: () {
                        Navigator.of(context).pop(); // 바텀 시트 닫기
                        // 포커스 해제하여 키보드 숨기기
                        _commentFocusNode.unfocus();
                      },
                    ),
                  ],
                ),
              );
            },
          ).whenComplete(() {
            // 바텀 시트가 닫힌 후에 포커스 해제
            _commentFocusNode.unfocus();
          });
        },
      );
    } else {
      return SizedBox.shrink(); // 작성자가 아닌 경우 빈 공간
    }
  }
}
