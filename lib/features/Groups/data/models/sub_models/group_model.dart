import 'package:folder_it/features/Groups/domain/entities/sub_entities/group_entity.dart';

class GroupModel extends GroupEntity {
   
    int creator;
    String creationDate;
    bool recordStatus;

    GroupModel({
        required super.groupId,
        required super.groupName,
        required this.creator,
        required this.creationDate,
        required this.recordStatus,
    });

    factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
        groupId: json["id"],
        groupName: json["groupName"],
        creator: json["creator"],
        creationDate: json["creationDate"],
        recordStatus: json["recordStatus"],
    );

    Map<String, dynamic> toJson() => {
        "id": groupId,
        "groupName": groupName,
        "creator": creator,
        "creationDate": creationDate,
        "recordStatus": recordStatus,
    };
}