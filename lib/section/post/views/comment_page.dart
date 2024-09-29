// import 'package:flutter/material.dart';
// import '../viewmodels/post_viewmodel.dart';
//
// class CommentPage extends StatelessWidget {
//   final String postId;
//   final PostViewModel postViewModel = PostViewModel();
//   TextEditingController _commentController = TextEditingController();
//
//   CommentPage(this.postId);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('댓글'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//               stream: postViewModel.getComments(postId),
//               builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
//                 if (!snapshot.hasData) return CircularProgressIndicator();
//                 var comments = snapshot.data!;
//                 return ListView.builder(
//                   itemCount: comments.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(comments[index]['comment']),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _commentController,
//                     decoration: InputDecoration(hintText: '댓글 입력'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () async {
//                     await postViewModel.addComment(postId, _commentController.text);
//                     _commentController.clear();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
