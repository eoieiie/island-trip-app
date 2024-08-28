/*
**id -  객체의 메모리 위치를 나타내는 내부적인 식별자**

**uid -  사용자를 식별하는 데 사용되며,**

**uuid - 고유한 식별자를 생성하는 데 사용됨**
 */

class IUser {
  final String? id;
  String? uid;
  String? nickname;
  String? thumbnail;
  String? description;
  String? email; // 이메일 추가
  int? currentPoints; // 현재 포인트 추가


  IUser({
    this.id,
    this.uid,
    this.nickname,
    this.thumbnail,
    this.description,
    this.email,
    this.currentPoints, // 현재 포인트 추가

  });

  factory IUser.fromJson(Map<String, dynamic> json) {
    return IUser(
      uid: json['uid'] as String?,
      nickname: json['nickname'] as String?,
      thumbnail: json['thumbnail'] as String?,
      description: json['description'] as String?,
      email: json['email'] as String?, // 이메일 추가
      currentPoints: json['currentPoints'] as int?, // 현재 포인트 추가
    );
  }

  IUser copyWith({
    String? id,
    String? uid,
    String? nickname,
    String? thumbnail,
    String? description,
    String? email, // 이메일 추가
    int? currentPoints, // 현재 포인트 추가
  }) {
    return IUser(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      email: email ?? this.email, // 이메일 추가
      currentPoints: currentPoints ?? this.currentPoints, // 현재 포인트 추가
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'nickname': nickname,
      'thumbnail': thumbnail,
      'description': description,
      'email': email, // 이메일 추가
      'currentPoints': currentPoints, // 현재 포인트 추가
    };
  }


}
