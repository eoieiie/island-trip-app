class IUser {
  String? uid;
  String? nickname;
  String? thumbnail;
  String? description;
  String? email; // 이메일 추가

  IUser({
    this.uid,
    this.nickname,
    this.thumbnail,
    this.description,
    this.email,
  });

  factory IUser.fromJson(Map<String, dynamic> json) {
    return IUser(
      uid: json['uid'] as String?,
      nickname: json['nickname'] as String?,
      thumbnail: json['thumbnail'] as String?,
      description: json['description'] as String?,
      email: json['email'] as String?, // 이메일 추가
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nickname': nickname,
      'thumbnail': thumbnail,
      'description': description,
      'email': email, // 이메일 추가
    };
  }

  IUser copyWith({
    String? uid,
    String? nickname,
    String? thumbnail,
    String? description,
    String? email, // 이메일 추가
  }) {
    return IUser(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      email: email ?? this.email, // 이메일 추가
    );
  }
}
