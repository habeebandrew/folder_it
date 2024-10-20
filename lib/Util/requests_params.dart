
class RequestParams {
  RequestParams({
    this.userName = "",
    this.fileTitle = "",
    this.updated = "",
    this.groupName = "",
    this.fileStatus = "",
    this.fileReserved = "",
  });

  String? groupName;
  String? userName;
  String? fileTitle;
  String? fileReserved;
  String? fileStatus;
  String? updated;
  RequestParams copyWith({
    String? userName,
    String? fileTitle,
    String? fileReserved,
    String? fileStatus,
    String? groupName,
    String? updated,
  }) =>
      RequestParams(
        userName: userName ?? this.userName,
        fileTitle: fileTitle ?? this.fileTitle,
        fileReserved: fileReserved ?? this.fileReserved,
        fileStatus:  fileStatus ?? this.fileStatus,
        groupName:  groupName ?? this.groupName,
        updated: updated ?? this.updated,
      );
  Map<String, dynamic> toJson() {
    // type = type ?? HomeRequestType.sections;
    return {
      "user_name": userName.toString(),
      "file_title": fileTitle.toString(),
      "reserved": fileReserved.toString(),
      "updated": updated.toString(),
      "file_status": fileStatus.toString(),
      "group_name": groupName.toString(),
    };
  }
}
