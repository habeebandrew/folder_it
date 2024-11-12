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
        id: json["id"],
        roleName: json["roleName"],
        recordStatus: json["recordStatus"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "roleName": roleName,
        "recordStatus": recordStatus,
    };
}