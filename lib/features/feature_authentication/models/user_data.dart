import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class UserData {
  String? id;
  String? username;
  String? phone;
  String? password;
  String? email;

  UserData({
    this.id,
    this.phone,
    this.password,
    this.username,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "phone": phone,
      "password": password,
      "email": email,
    };
  }

  factory UserData.fromJson(Map<String, dynamic>? json) {
    return UserData(
      phone: json?["phone"],
      password: json?["password"],
      username: json?["username"],
      email: json?["email"],
    );
  }

  factory UserData.fromString({required String? data}) {
    return UserData.fromJson(jsonDecode(data ?? "{}"));
  }

// data  factory UserData.fromSnapshot(DataSnapshot snapshot, String username){
//     return UserData(
//       phone: snapshot.value![""],
//       password: snapshot.value?["password"],
//       username: snapshot.value?[username],
//       email: snapshot.value?["email"],
//     );
//   }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
