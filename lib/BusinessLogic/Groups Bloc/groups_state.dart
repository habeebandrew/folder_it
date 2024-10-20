part of 'groups_bloc.dart';

abstract class GroupsState {}

class GroupsInitialState extends GroupsState {}

class GroupsLoadingState extends GroupsState {}

class GroupsPostedState extends GroupsState {}

class GroupsLoadedState extends GroupsState {
  GroupsLoadedState({required this.groups, this.selectedGroup = 0});
  List<Group> groups;
  int selectedGroup;

  GroupsLoadedState copyWith({
    List<Group>? groups,
    int? selectedGroup,
  }) {
    return GroupsLoadedState(
      groups: groups ?? this.groups,
      selectedGroup: selectedGroup ?? this.selectedGroup,
    );
  }
}

class GroupsErrorState extends GroupsState {
  GroupsErrorState({required this.error});
  String error;
}
