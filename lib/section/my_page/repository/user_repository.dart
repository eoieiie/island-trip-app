import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_island/section/my_page/model/user_model.dart';

class UserRepository {
  static IUser? currentUser;

  // 사용자 로그인
  static Future<IUser?> loginUserByUid(String uid) async {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();

    if (data.size == 0) {
      return null;
    } else {
      var userData = data.docs.first.data();
      currentUser = IUser.fromJson(userData);
      return currentUser;
    }
  }

  // 사용자 가입
  static Future<bool> signup(IUser user) async {
    try {
      await FirebaseFirestore.instance.collection('users').add(user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  // 사용자 업데이트
  static Future<bool> updateUser(IUser user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(user.toMap());
      currentUser = user;
      return true;
    } catch (e) {
      return false;
    }
  }
}
