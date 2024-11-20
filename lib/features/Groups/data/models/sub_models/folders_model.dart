import 'package:folder_it/core/databases/api/end_points.dart';

class FoldersModel {
    int id;
    dynamic parentId;
    String folderName;
    int creator;
    bool restricted;
    String creationDate;

    FoldersModel({
        required this.id,
        required this.parentId,
        required this.folderName,
        required this.creator,
        required this.restricted,
        required this.creationDate,
    });

    factory FoldersModel.fromJson(Map<String, dynamic> json) => FoldersModel(
        id: json[ApiKey.id],
        parentId: json[ApiKey.parentId],
        folderName: json[ApiKey.folderName],
        creator: json[ApiKey.creator],
        restricted: json[ApiKey.restricted],
        creationDate: json[ApiKey.creationDate],
    );

    Map<String, dynamic> toJson() => {
        ApiKey.id: id,
        ApiKey.parentId: parentId,
        ApiKey.folderName: folderName,
        ApiKey.creator: creator,
        ApiKey.restricted: restricted,
        ApiKey.creationDate: creationDate,
    };
}