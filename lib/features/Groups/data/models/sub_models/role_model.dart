import 'package:folder_it/core/databases/api/end_points.dart';

class RoleModel {
    int id;
    String roleName;
    bool recordStatus;

    RoleModel({
        required this.id,
        required this.roleName,
        required this.recordStatus,
    });

    factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
        id: json[ApiKey.id],
        roleName: json[ApiKey.roleName],
        recordStatus: json[ApiKey.recordStatus],
    );

    Map<String, dynamic> toJson() => {
        ApiKey.id: id,
        ApiKey.roleName: roleName,
        ApiKey.recordStatus: recordStatus,
    };
}