import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  bool success;
  List<Group> data;

  Welcome({
    required this.success,
    required this.data,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        success: json["success"],
        data: List<Group>.from(json["data"].map((x) => Group.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Group {
  int id;
  String name;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<FileElement>? files;

  Group({
    this.id = 0,
    this.name = '',
    this.createdAt,
    this.updatedAt,
    this.files,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        files: json["files"] == null
            ? null
            : List<FileElement>.from(
                json["files"].map((x) => FileElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "files": List<dynamic>.from(files!.map((x) => x.toJson())),
      };
}

class FileElement {
  int id;
  int userId;
  int groupId;
  int status;
  String title;
  String url;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? processes;

  FileElement({
    this.id = 0,
    this.userId = 0,
    this.groupId = 0,
    this.status = 0,
    this.title = "",
    this.url = "",
    this.createdAt,
    this.updatedAt,
    this.processes,
  });

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        groupId: json["group_id"] ?? 0,
        status: json["status"] ?? 0,
        title: json["title"] ?? "",
        url: json["url"] ?? "",
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        processes: json["processes"] == null
            ? null
            : List<dynamic>.from(json["processes"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "group_id": groupId,
        "status": status,
        "title": title,
        "url": url,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "processes": List<dynamic>.from(processes!.map((x) => x)),
      };
}
