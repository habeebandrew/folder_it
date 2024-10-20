import 'dart:convert';

import 'package:internet_applications/Data/user_model.dart';

import 'groups_model.dart';

WelcomeProcesses welcomeProcessesFromJson(String str) =>
    WelcomeProcesses.fromJson(json.decode(str));

String welcomeProcessesToJson(WelcomeProcesses data) =>
    json.encode(data.toJson());

class WelcomeProcesses {
    List<ProcessModel>? data;

  WelcomeProcesses({
    this.data,
  });

  factory WelcomeProcesses.fromJson(Map<String, dynamic> json) =>
      WelcomeProcesses(
        data: json["data"] == null
            ? []
            : List<ProcessModel>.from(
                json["data"]!.map((x) => ProcessModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ProcessModel {
  int? id;
  int? userId;
  int? fileId;
  int? updated;
  int? reserved;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  FileElement? file;

  ProcessModel({
    this.id,
    this.userId,
    this.fileId,
    this.updated,
    this.reserved,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.file,
  });

  factory ProcessModel.fromJson(Map<String, dynamic> json) => ProcessModel(
        id: json["id"],
        userId: json["user_id"],
        fileId: json["file_id"],
        updated: json["updated"],
        reserved: json["reserved"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        file: json["file"] == null ? null : FileElement.fromJson(json["file"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "file_id": fileId,
        "updated": updated,
        "reserved": reserved,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
        "file": file?.toJson(),
      };
}
