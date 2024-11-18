// import 'package:bloc/bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// // GroupCubit: لإدارة حالة مجموعات البيانات
// class GroupCubitView extends Cubit<GroupState> {
//   GroupCubitView() : super(GroupInitial());
//
//   List<Group> groups = [];
//   String selectedCategory = 'All';
//   bool sortByNewest = true;
//
//   void fetchGroups(int creatorId) async {
//     emit(GroupLoading());
//     try {
//       final response = await http.get(
//         Uri.parse("http://127.0.0.1:8091/group/my-groups?creatorId=$creatorId"),
//       );
//
//       if (response.statusCode == 200) {
//         List jsonResponse = json.decode(response.body);
//         groups = jsonResponse.map((data) => Group.fromJson(data)).toList();
//         emit(GroupLoaded(groups));
//       } else {
//         emit(GroupError('Failed to load groups'));
//       }
//     } catch (error) {
//       emit(GroupError(error.toString()));
//     }
//   }
//
//   void setCategory(String category) {
//     selectedCategory = category;
//     emit(GroupFilterUpdated());
//   }
//
//   void toggleSortOrder() {
//     sortByNewest = !sortByNewest;
//     emit(GroupFilterUpdated());
//   }
//
//   List<Group> getFilteredGroups() {
//     List<Group> filteredGroups = groups.where((group) {
//       if (selectedCategory == 'Deleted') {
//         return !group.recordStatus;
//       } else if (selectedCategory == 'My Groups') {
//         return group.recordStatus;
//       }
//       return true;
//     }).toList();
//
//     filteredGroups.sort((a, b) {
//       return sortByNewest
//           ? b.creationDate.compareTo(a.creationDate)
//           : a.creationDate.compareTo(b.creationDate);
//     });
//
//     return filteredGroups;
//   }
// }
//
// // تعريف الحالات المختلفة
// abstract class GroupState {}
//
// class GroupInitial extends GroupState {}
//
// class GroupLoading extends GroupState {}
//
// class GroupLoaded extends GroupState {
//   final List<Group> groups;
//
//   GroupLoaded(this.groups);
// }
//
// class GroupFilterUpdated extends GroupState {}
//
// class GroupError extends GroupState {
//   final String message;
//
//   GroupError(this.message);
// }
// class Group {
//   final int id;
//   final String groupName;
//   final int creator;
//   final DateTime creationDate;
//   final bool recordStatus;
//
//   Group({
//     required this.id,
//     required this.groupName,
//     required this.creator,
//     required this.creationDate,
//     required this.recordStatus,
//   });
//
//   factory Group.fromJson(Map<String, dynamic> json) {
//     return Group(
//       id: json['id'],
//       groupName: json['groupName'],
//       creator: json['creator'],
//       creationDate: DateTime.parse(json['creationDate']),
//       recordStatus: json['recordStatus'],
//     );
//   }
// }
