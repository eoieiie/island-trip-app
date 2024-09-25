import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../models/post.dart';

class PostViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 게시글 리스트 가져오기 (최신순으로 정렬)
  Stream<List<Post>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true) // 최신순으로 정렬
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post.fromDocument(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // 게시글 추가
  Future<void> addPost(String title, String content, File? image) async {
    String? imageUrl;
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? userName = currentUser?.displayName ?? 'Unknown'; // 사용자 이름 가져오기

    // 이미지가 있으면 Firebase Storage에 업로드
    if (image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('posts/${DateTime.now().toIso8601String()}.jpg');
      await ref.putFile(image);
      imageUrl = await ref.getDownloadURL();
    }

    // Firestore에 게시글 추가
    await _firestore.collection('posts').add({
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'author': userName, // 작성자 이름 저장
      'authorId': currentUser?.uid, // 작성자 ID 저장
      'timestamp': Timestamp.now(),
    });
  }

  // 게시글 세부 정보 가져오기
  Future<Map<String, dynamic>> getPostDetail(String postId) async {
    DocumentSnapshot doc = await _firestore.collection('posts').doc(postId).get();
    return doc.data() as Map<String, dynamic>;
  }

  // 댓글 추가
  Future<void> addComment(String postId, String comment) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? userName = currentUser?.displayName ?? 'Unknown'; // 사용자 이름 가져오기

    await _firestore.collection('posts').doc(postId).collection('comments').add({
      'comment': comment,
      'author': userName, // 댓글 작성자 이름 저장
      'authorId': currentUser?.uid, // 댓글 작성자 ID 저장
      'timestamp': Timestamp.now(),
    });
  }

  // 댓글 리스트 가져오기
  Stream<List<Map<String, dynamic>>> getComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id; // 댓글의 문서 ID를 데이터에 포함
        return data;
      }).toList();
    });
  }
  // 게시글의 댓글 수 가져오기
  Future<int> getCommentCount(String postId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get();
    return snapshot.docs.length;
  }

  // 게시글 삭제
  Future<void> deletePost(String postId) async {
    // 트랜잭션 사용하여 원자적으로 삭제 처리
    await _firestore.runTransaction((transaction) async {
      // 게시글 문서 참조
      DocumentReference postRef = _firestore.collection('posts').doc(postId);

      // 댓글 컬렉션의 모든 문서 가져오기
      QuerySnapshot commentsSnapshot = await postRef.collection('comments').get();

      // 각 댓글 문서를 순회하며 삭제
      for (DocumentSnapshot commentDoc in commentsSnapshot.docs) {
        transaction.delete(commentDoc.reference);
      }

      // 게시글 삭제
      transaction.delete(postRef);
    });
  }

  // 댓글 삭제
  Future<void> deleteComment(String postId, String commentId) async {
    await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).delete();
  }

  // 게시글 수정
  Future<void> updatePost(String postId, String newTitle, String newContent) async {
    await _firestore.collection('posts').doc(postId).update({
      'title': newTitle,
      'content': newContent,
      'timestamp': Timestamp.now(), // 수정 시간 업데이트
    });
  }

  // 댓글 수정
  Future<void> updateComment(String postId, String commentId, String newComment) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .update({
      'comment': newComment,
      'timestamp': Timestamp.now(), // 수정 시간 업데이트
    });
  }

  // 이미지 선택 (ImagePicker 사용)
  Future<File?> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
