// To parse this JSON data, do
//
//     final inviteModel = inviteModelFromJson(jsonString);

import 'dart:convert';

import 'package:folder_it/features/Groups/data/models/sub_models/group_model.dart';
import 'package:folder_it/features/Groups/data/models/sub_models/role_model.dart';
import 'package:folder_it/features/Groups/domain/entities/invite_entity.dart';
import 'package:folder_it/features/User/data/models/user_model.dart';

List<InviteModel> inviteModelFromJson(String str) => List<InviteModel>.from(json.decode(str).map((x) => InviteModel.fromJson(x)));

String inviteModelToJson(List<InviteModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InviteModel extends InviteEntity {
   
    String creationDate;
    dynamic modifiedDate;
    int inviteStatus;
    String inviteDate;
    bool recordStatus;
    UserModel user;
    RoleModel role;
  

    InviteModel({
        required super.inviteId,
        required this.creationDate,
        required this.modifiedDate,
        required this.inviteStatus,
        required this.inviteDate,
        required this.recordStatus,
        required this.user,
        required this.role,
        required super.group,
    });

    factory InviteModel.fromJson(Map<String, dynamic> json) => InviteModel(
        inviteId: json["id"],
        creationDate: json["creationDate"],
        modifiedDate: json["modifiedDate"],
        inviteStatus: json["inviteStatus"],
        inviteDate: json["inviteDate"],
        recordStatus: json["recordStatus"],
        user: UserModel.fromJson(json["user"]),
        role: RoleModel.fromJson(json["role"]),
        group: GroupModel.fromJson(json["group"]),
    );

    Map<String, dynamic> toJson() => {
        "id": inviteId,
        "creationDate": creationDate,
        "modifiedDate": modifiedDate,
        "inviteStatus": inviteStatus,
        "inviteDate": inviteDate,
        "recordStatus": recordStatus,
        "user": user.toJson(),
        "role": role.toJson(),
        "group": group,
    };
}






