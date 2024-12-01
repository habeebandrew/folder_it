// To parse this JSON data, do
//
//     final inviteModel = inviteModelFromJson(jsonString);

import 'dart:convert';

import 'package:folder_it/core/databases/api/end_points.dart';
import 'package:folder_it/features/Groups/data/models/sub_models/group_model.dart';
import 'package:folder_it/features/Groups/data/models/sub_models/role_model.dart';
import 'package:folder_it/features/Groups/domain/entities/invite_entity.dart';
import 'package:folder_it/features/User/data/models/user_model.dart';

List<InviteModel> inviteModelFromJson(String str) {
    final jsonData = json.decode(str);
    return List<InviteModel>.from(jsonData.map((x) => InviteModel.fromJson(x)));
}
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
        inviteId: json[ApiKey.id],
        creationDate: json[ApiKey.creationDate],
        modifiedDate: json[ApiKey.modifiedDate],
        inviteStatus: json[ApiKey.inviteStatus],
        inviteDate: json[ApiKey.inviteDate],
        recordStatus: json[ApiKey.recordStatus],
        user: UserModel.fromJson(json[ApiKey.user]),
        role: RoleModel.fromJson(json[ApiKey.role]),
        group: GroupModel.fromJson(json[ApiKey.group]),
    );

    Map<String, dynamic> toJson() => {
        ApiKey.id: inviteId,
        ApiKey.creationDate: creationDate,
        ApiKey.modifiedDate: modifiedDate,
        ApiKey.inviteStatus: inviteStatus,
        ApiKey.inviteDate: inviteDate,
        ApiKey.recordStatus: recordStatus,
        ApiKey.user: user.toJson(),
        ApiKey.role: role.toJson(),
        ApiKey.group: group,
    };
}






