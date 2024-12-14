// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';


import 'package:folder_it/core/databases/api/end_points.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel  {
    int id;
    String userName;
    String email;
    String password;
    String creationDate;
    bool recordStatus;
    dynamic userRoleGroups;
    String?token;
    String?refreshToken;

    UserModel({
        required this.id,
        required this.userName,
        required this.email,
        required this.password,
        required this.creationDate,
        required this.recordStatus,
        required this.userRoleGroups,
        required this.token,
        required this.refreshToken,

    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json[ApiKey.id],
        userName: json[ApiKey.username],
        email: json[ApiKey.email],
        password: json[ApiKey.password],
        creationDate: json[ApiKey.creationDate],
        recordStatus: json[ApiKey.recordStatus],
        userRoleGroups: json[ApiKey.userRoleGroups],
        token: json[ApiKey.token],
        refreshToken: json[ApiKey.refreshToken],

    );

    Map<String, dynamic> toJson() => {
        ApiKey.id: id,
        ApiKey.username: userName,
        ApiKey.email: email,
        ApiKey.password: password,
        ApiKey.creationDate: creationDate,
        ApiKey.recordStatus: recordStatus,
        ApiKey.userRoleGroups: userRoleGroups,
        ApiKey.token: token,
        ApiKey.refreshToken: refreshToken,

    };
}
