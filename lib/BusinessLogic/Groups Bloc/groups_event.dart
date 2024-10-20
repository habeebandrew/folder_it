part of 'groups_bloc.dart';

abstract class GroupsEvent {}

class GetGroupsEvent extends GroupsEvent {
  GetGroupsEvent({this.requestParams});
  RequestParams? requestParams;
}

class DeleteGroupEvent extends GroupsEvent {
  DeleteGroupEvent({required this.groupId});
  int groupId;
}



class ExitGroupEvent extends GroupsEvent {
  ExitGroupEvent({required this.groupId});
  int groupId;
}

class RemoveMemberGroupEvent extends GroupsEvent {
  RemoveMemberGroupEvent({required this.groupId,required this.memberId});
  int groupId;
  int memberId;
}

class SelectGroupsEvent extends GroupsEvent {
  SelectGroupsEvent({required this.groupId});
  int groupId;
}
class CreateGroupEvent extends GroupsEvent {
  CreateGroupEvent({required this.groupName});
  String groupName;
}

class InviteMemberToGroupsEvent extends GroupsEvent {
  InviteMemberToGroupsEvent({
    required this.groupId,
    required this.emails,
  });
  int groupId;
  List<String> emails;
}
class UploadFileToGroupsEvent extends GroupsEvent {
  UploadFileToGroupsEvent({
    required this.groupId,
    required this.webFile,
    required this.fileName,
  });
  int groupId;
  String fileName;
  Uint8List webFile;
}

class UpdateFileInGroupsEvent extends GroupsEvent {
  UpdateFileInGroupsEvent({
    required this.groupId,
    required this.fileId,
    required this.webFile,
  });
  int groupId;
  int fileId;
  Uint8List webFile;
}

class CreateGroupsEvent extends GroupsEvent {
  CreateGroupsEvent({required this.groupName});
  String groupName;
}
class ReserveFilesInGroupsEvent extends GroupsEvent {
  ReserveFilesInGroupsEvent({
    required this.reserve,
    required this.unreserve,
    // required this.groupId
  });
  // int groupId;
  List<int> reserve;
  List<int> unreserve;
}
