import 'package:folder_it/core/databases/api/end_points.dart';
import 'package:folder_it/features/Groups/data/models/sub_models/folders_model.dart';
import 'package:folder_it/features/Groups/domain/entities/sub_entities/group_entity.dart';

class GroupModel extends GroupEntity {
   
    int creator;
    String creationDate;
    bool recordStatus;
    List<FoldersModel> folders;
    GroupModel({
        required super.groupId,
        required super.groupName,
        required this.creator,
        required this.creationDate,
        required this.recordStatus,
        required this.folders
    });

    factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
        groupId: json[ApiKey.id],
        groupName: json[ApiKey.groupName],
        creator: json[ApiKey.creator],
        creationDate: json[ApiKey.creationDate],
        recordStatus: json[ApiKey.recordStatus],
        folders: List<FoldersModel>.from(json["folders"].map((x) => FoldersModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        ApiKey.id: groupId,
        ApiKey.groupName: groupName,
        ApiKey.creator: creator,
        ApiKey.creationDate: creationDate,
        ApiKey.recordStatus: recordStatus,
        ApiKey.folders:List<dynamic>.from(folders.map((x) => x.toJson())),
        
    };
}