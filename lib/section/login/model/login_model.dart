import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth 인스턴스 생성
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // GoogleSignIn 인스턴스 생성

  // Google 로그인 메서드
  Future<User?> signInWithGoogle() async {
    try {
      // Google 로그인 프로세스 시작
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // 사용자가 로그인 과정에서 취소를 한 경우
        return null;
      }

      // 로그인 성공, 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Firebase에 인증 정보 전달
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase에서 로그인 처리 및 사용자 반환
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // 로그인된 사용자 정보를 가져옴
      final User? user = userCredential.user;

      // 사용자 정보 출력
      if (user != null) {
        printUserInfo(user);  // 사용자 정보 출력
      }

      return user;
    } catch (e) {
      // 에러 발생 시 처리
      print(e.toString());
      return null;
    }
  }

  // 현재 로그인된 사용자 확인
  User? googleGetCurrentUser() {
    return _auth.currentUser; // 현재 로그인된 사용자 반환 (로그인되지 않았다면 null 반환)
  }

  // 로그아웃 메서드 (옵션)
  Future<void> googleSignOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  void printUserInfo(User user) {
    print('--- Firebase User Info ---');
    print('UID: ${user.uid}');
    print('Email: ${user.email}');
    print('Display Name: ${user.displayName}');
    print('Photo URL: ${user.photoURL}');
    print('Phone Number: ${user.phoneNumber}');
    print('Provider ID: ${user.providerData.map((info) => info.providerId).join(', ')}');
    print('--------------------------');
  }
}
