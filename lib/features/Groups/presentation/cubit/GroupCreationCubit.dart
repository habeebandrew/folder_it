// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
//
// class GroupCreationCubit extends Cubit<GroupCreationState> {
//   GroupCreationCubit() : super(GroupCreationInitial());
//
//   Future<void> createGroup(String groupName, int creatorId) async {
//     emit(GroupCreationLoading());
//     const String apiUrl = 'http://localhost:8091/group/add';
//     final Map<String, dynamic> requestBody = {
//       'groupName': groupName,
//       'creator': creatorId,
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
//         body: jsonEncode(requestBody),
//       );
//
//       if (response.statusCode == 200) {
//         emit(GroupCreationSuccess(groupName));
//       } else {
//         emit(GroupCreationFailure('Failed to create group: ${response.body}'));
//       }
//     } catch (e) {
//       emit(GroupCreationFailure('Error occurred: $e'));
//     }
//   }
// }
//
// @immutable
// abstract class GroupCreationState {}
//
// class GroupCreationInitial extends GroupCreationState {}
//
// class GroupCreationLoading extends GroupCreationState {}
//
// class GroupCreationSuccess extends GroupCreationState {
//   final String groupName;
//   GroupCreationSuccess(this.groupName);
// }
//
// class GroupCreationFailure extends GroupCreationState {
//   final String errorMessage;
//   GroupCreationFailure(this.errorMessage);
// }
