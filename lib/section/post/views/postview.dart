import 'package:flutter/material.dart';
import '../viewmodels/post_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostDetailPage extends StatefulWidget {
  final String postId;

  PostDetailPage({required this.postId});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final PostViewModel postViewModel = PostViewModel();
  TextEditingController _commentController = TextEditingController();
  FocusNode _commentFocusNode = FocusNode();
  Map<String, dynamic>? postData;

  Future<void> _refreshPostData() async {
    await _loadPostData();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadPostData();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadPostData() async {
    var post = await postViewModel.getPostDetail(widget.postId);
    setState(() {
      postData = post;
    });
  }

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

  // 댓글 수정 모달 바텀 시트
  void _showEditCommentBottomSheet(
      BuildContext context, Map<String, dynamic> comment) {
    TextEditingController _commentController =
    TextEditingController(text: comment['comment']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '댓글 수정',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width * 0.88,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '댓글',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      cursorColor: Colors.black!,
                      selectionColor: Color(0xFF1BB874),
                      selectionHandleColor: Color(0xFF1BB874),
                    ),
                  ),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: ' 댓글을 수정하세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Color(0xFF6699FF),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                    maxLines: 3,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      // 수정된 댓글 저장 처리
                      await postViewModel.updateComment(
                        widget.postId,
                        comment['id'],
                        _commentController.text,
                      );
                      Navigator.pop(context); // 모달 닫기
                      _refreshPostData(); // 수정 후 새로고침
                    },
                    child: Text(
                      '저장',
                      style: TextStyle(color: Color(0xFF6EBF54)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // 모달 닫기
                    },
                    child: Text('취소', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // 게시글 수정 모달 바텀 시트 수정
  void _showEditPostBottomSheet(BuildContext context) {
    TextEditingController _titleController =
    TextEditingController(text: postData!['title']);
    TextEditingController _contentController =
    TextEditingController(text: postData!['content']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent, // 빈 화면 터치 시 키보드 내리기
          onTap: () {
            FocusScope.of(context).unfocus(); // 키보드 내림
          },
          child: SingleChildScrollView( // 스크롤 가능하게 만듦
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center, // 전체 컬럼의 가운데 정렬
                children: [
                  // 게시글 수정 텍스트
                  Text(
                    '게시글 수정',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  // 제목 필드
                  Container(
                    width: MediaQuery.of(context).size.width * 0.88,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '제목',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  // 제목 입력 필드
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: ' 제목 수정',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.grey[200]!, // 기본 테두리 색상을 grey[200]으로 설정
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color(0xFF1BB874), // 포커스 시 초록색 테두리
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.grey[200]!, // 비활성화 시 테두리 색
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  // 내용 필드
                  Container(
                    width: MediaQuery.of(context).size.width * 0.88,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '내용',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  // 내용 입력 필드
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        hintText: ' 내용 수정',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.grey[200]!, // 기본 테두리 색상 grey[200]으로 설정
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color(0xFF1BB874), // 포커스 시 초록색 테두리
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.grey[200]!, // 비활성화 시 테두리 색
                            width: 1,
                          ),
                        ),
                      ),
                      maxLines: 5,
                    ),
                  ),
                  SizedBox(height: 16),
                  // 저장 및 취소 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end, // 버튼을 오른쪽 정렬
                    children: [
                      TextButton(
                        onPressed: () async {
                          // 수정된 게시글 저장 처리
                          await postViewModel.updatePost(
                            widget.postId,
                            _titleController.text,
                            _contentController.text,
                          );
                          Navigator.pop(context); // 모달 닫기
                          _refreshPostData(); // 수정 후 새로고침
                        },
                        child: Text(
                          '저장',
                          style: TextStyle(color: Color(0xFF6EBF54)),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // 모달 닫기
                        },
                        child: Text(
                          '취소',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  // 게시글 옵션 모달 바텀 시트 (수정, 삭제, 닫기)
  void _showPostOptionsBottomSheet(
      BuildContext context, BuildContext parentContext) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: Color(0xFF6EBF54),
                ),
                title: Text('수정'),
                onTap: () {
                  Navigator.of(context).pop(); // 현재 바텀 시트 닫기
                  _showEditPostBottomSheet(context); // 수정 바텀 시트 열기
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Color(0xFFE57373),
                ),
                title: Text('삭제'),
                onTap: () async {
                  Navigator.of(context).pop(); // 바텀 시트 닫기
                  bool? confirmDelete = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          '정말 삭제하시겠습니까?',
                          style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              '네',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                          TextButton(
                            child: Text('아니오', style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                        ],
                      );
                    },
                  );
                  if (confirmDelete == true) {
                    await postViewModel.deletePost(widget.postId);

                    // 게시글 삭제 후 상위 네비게이션 스택으로 돌아가기
                    Navigator.of(parentContext)
                        .pop(); // parentContext 사용해 PostDetailPage 닫기
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.close),
                title: Text('닫기'),
                onTap: () {
                  Navigator.of(context).pop(); // 바텀 시트 닫기
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 댓글 옵션 모달 바텀 시트 (수정, 삭제, 닫기)
  void _showCommentOptionsBottomSheet(
      BuildContext context, Map<String, dynamic> comment) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: Color(0xFF6EBF54),
                ),
                title: Text('수정'),
                onTap: () {
                  Navigator.of(context).pop(); // 현재 바텀 시트 닫기
                  _showEditCommentBottomSheet(context, comment); // 수정 바텀 시트 열기
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete,
                  color: Color(0xFFE57373),
                ),
                title: Text('삭제'),
                onTap: () async {
                  Navigator.of(context).pop(); // 바텀 시트 닫기
                  bool? confirmDelete = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          '정말 삭제하시겠습니까?',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('네', style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                          TextButton(
                            child: Text('아니오', style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                        ],
                      );
                    },
                  );
                  if (confirmDelete == true) {
                    await postViewModel.deleteComment(
                        widget.postId, comment['id']);
                    _refreshPostData(); // 새로고침
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.close),
                title: Text('닫기'),
                onTap: () {
                  Navigator.of(context).pop(); // 바텀 시트 닫기
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final parentContext = context;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
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
                Navigator.pop(context);
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
                _commentFocusNode.unfocus();
                _showPostOptionsBottomSheet(context, parentContext);
              },
            ),
        ],
      ),
      body: postData == null
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              color: Color(0xFF3CCB7F),
              onRefresh: _refreshPostData,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          postData!['title'],
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.person,
                                size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                postData!['author'],
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 16),
                            Icon(Icons.access_time,
                                size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(
                              DateFormat('yyyy-MM-dd HH:mm').format(
                                  postData!['timestamp'].toDate()),
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Divider(thickness: 1, color: Colors.grey[300]),
                        SizedBox(height: 30),
                        Text(
                          postData!['content'],
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 30),
                        Divider(thickness: 1, color: Colors.grey[300]),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    child: Text(
                      '댓글',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  StreamBuilder(
                    stream: postViewModel.getComments(widget.postId),
                    builder: (context,
                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('댓글을 불러오는 중 오류가 발생했습니다.'));
                      } else if (!snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return Center(child: Text('댓글이 없습니다.'));
                      } else {
                        var comments = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            var comment = comments[index];
                            return Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.person,
                                                    size: 15,
                                                    color: Colors.grey),
                                                SizedBox(width: 3),
                                                Text(
                                                  comment['author'],
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color:
                                                    Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Text(
                                                comment['comment'],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.w300),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  left: 2.0),
                                              child: Text(
                                                DateFormat(
                                                    'yyyy-MM-dd HH:mm')
                                                    .format(comment[
                                                'timestamp']
                                                    .toDate()),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                  Colors.grey[500],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (FirebaseAuth.instance
                                          .currentUser?.uid ==
                                          comment['authorId'])
                                        IconButton(
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Color(0xFF6EBF54),
                                          ),
                                          onPressed: () {
                                            _commentFocusNode.unfocus();
                                            _showCommentOptionsBottomSheet(
                                                context,
                                                comment); // 댓글 옵션 바텀 시트 열기
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
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
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 12.0, right: 8.0, bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          cursorColor: Colors.black,
                          selectionColor: Color(0xFFBBDDFF),
                          selectionHandleColor: Color(0xFF6699FF),
                        ),
                      ),
                      child: TextField(
                        controller: _commentController,
                        focusNode: _commentFocusNode,
                        cursorColor: Colors.black,
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
                        _commentFocusNode.unfocus();
                        await postViewModel.addComment(widget.postId,
                            _commentController.text.trim());
                        _commentController.clear();
                        _refreshPostData();
                      } else {
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
}
