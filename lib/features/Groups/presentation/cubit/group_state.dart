
part of 'group_cubit.dart';

abstract class GroupState {}

class UserAuthInitialState extends GroupState {}

class GroupLoadingState extends GroupState {}

class GroupSuccessState extends GroupState {
 
}

class GroupGetInvitesSuccess extends GroupState{
  List<InviteEntity>invites;
  GroupGetInvitesSuccess({required this.invites});
}

class GroupFailureState extends GroupState {
  final String message;

  GroupFailureState({required this.message});
}


