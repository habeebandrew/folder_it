// import 'dart:async';
// import 'dart:developer';
// import 'dart:typed_data';
// import 'package:bloc/bloc.dart';
// import '../../Data/groups_model.dart';
// import '../../Util/enums.dart';
// import '../../Util/requests_params.dart';
// import 'groups_service.dart';
// part 'groups_event.dart';
// part 'groups_state.dart';
//
// class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
//   GroupsService groupsService = GroupsService();
//
//   GroupsBloc() : super(GroupsInitialState()) {
//
//     on<GetGroupsEvent>((event, emit) async {
//       emit(GroupsLoadingState());
//       final allItems = await groupsService.getGroups();
//
//       if (allItems is List<Group>) {
//         emit(GroupsLoadedState(
//             groups: allItems,
//             selectedGroup: allItems.isNotEmpty ? allItems[0].id : -1));
//       } else if (allItems is String || allItems is ServicesResponseStatues) {
//         emit(GroupsErrorState(error: allItems.toString()));
//       }
//     });
//
//     on<CreateGroupsEvent>((event, emit) async {
//       emit(GroupsLoadingState());
//       final response = await groupsService.createGroups(name: event.groupName);
//       if (response == ServicesResponseStatues.success) {
//         emit(GroupsPostedState());
//         return;
//       } else {
//         emit(GroupsErrorState(error: response.toString()));
//       }
//     });
//
//     on<ReserveFilesInGroupsEvent>((event, emit) async {
//       emit(GroupsLoadingState());
//       final response = await groupsService.reserveFiles(
//           reserve: event.reserve,
//           unreserve: event.unreserve,
//       );
//
//       if (response == ServicesResponseStatues.success) {
//         emit(GroupsPostedState());
//         return;
//       } else {
//         emit(GroupsErrorState(error: response.toString()));
//       }
//     });
//
//     on<InviteMemberToGroupsEvent>((event, emit) async {
//       emit(GroupsLoadingState());
//       final response = await groupsService.inviteMemberToGroup(
//           emails: event.emails, groupId: event.groupId);
//
//       if (response == ServicesResponseStatues.success) {
//         emit(GroupsPostedState());
//
//         return;
//       } else {
//         emit(GroupsErrorState(error: response.toString()));
//       }
//     });
//
//     on<UploadFileToGroupsEvent>((event, emit) async {
//       emit(GroupsLoadingState());
//       final response = await groupsService.uploadFileToGroup(
//           webFile: event.webFile,
//           fileName: event.fileName,
//           groupId: event.groupId);
//       log(response.toString());
//       if (response == ServicesResponseStatues.success) {
//         emit(GroupsPostedState());
//         return;
//       } else {
//         emit(GroupsErrorState(error: response.toString()));
//       }
//     });
//
//     on<UpdateFileInGroupsEvent>((event, emit) async {
//       emit(GroupsLoadingState());
//       final response = await groupsService.updateFileInGroup(
//           webFile: event.webFile,
//           fileId: event.fileId,
//           groupId: event.groupId);
//       log(response.toString());
//       if (response == ServicesResponseStatues.success) {
//         emit(GroupsPostedState());
//         return;
//       } else {
//         emit(GroupsErrorState(error: response.toString()));
//       }
//     });
//
//   }
// }
