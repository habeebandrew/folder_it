import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


Future<WelcomeUser?> getUserFromLocalStorage() async {
  final prefs = await SharedPreferences.getInstance();
  WelcomeUser? uerModel = prefs.getString("user") != null
      ? welcomeUserFromJson(jsonDecode(prefs.getString("user")!))
      : null;
  if (uerModel == null) {
    return null;
  }
  return uerModel;
}

Future saveUserToLocalStorage(WelcomeUser userModel) async {
  String userString = json.encode(welcomeUserToJson(userModel));
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("user", userString);
}

Future<String?> getTokenFromLocalStorage() async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("token");
  if (token == null) {
    return null;
  }
  return jsonDecode(token);
}

Future saveTokenToLocalStorage(String token) async {
  String value = json.encode(token);
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("token", value);
}

Future deleteFromLocal() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("token");
  prefs.remove("user");
}

WelcomeUser welcomeUserFromJson(String str) => WelcomeUser.fromJson(json.decode(str));

  String welcomeUserToJson(WelcomeUser data) => json.encode(data.toJson());

class WelcomeUser {
  String token;
  User? user;

  WelcomeUser({
     this.token='',
     this.user,
  });

  factory WelcomeUser.fromJson(Map<String, dynamic> json) => WelcomeUser(
    token: json["token"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user!.toJson(),
  };
}

class User {
  int id;
  String name;
  String email;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
     this.id=0,
     this.name="",
     this.email="",
     this.createdAt,
     this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"]??0,
    name: json["name"]??"",
    email: json["email"]??"",
    createdAt:json["created_at"]==null?null: DateTime.parse(json["created_at"]),
    updatedAt:json["updated_at"]==null?null: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
