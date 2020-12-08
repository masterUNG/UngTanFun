import 'dart:convert';

class UserModel {
  final String avatar;
  final String email;
  final String name;
  final String password;
  UserModel({
    this.avatar,
    this.email,
    this.name,
    this.password,
  });

  UserModel copyWith({
    String avatar,
    String email,
    String name,
    String password,
  }) {
    return UserModel(
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'avatar': avatar,
      'email': email,
      'name': name,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return UserModel(
      avatar: map['avatar'],
      email: map['email'],
      name: map['name'],
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(avatar: $avatar, email: $email, name: $name, password: $password)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is UserModel &&
      o.avatar == avatar &&
      o.email == email &&
      o.name == name &&
      o.password == password;
  }

  @override
  int get hashCode {
    return avatar.hashCode ^
      email.hashCode ^
      name.hashCode ^
      password.hashCode;
  }
}
