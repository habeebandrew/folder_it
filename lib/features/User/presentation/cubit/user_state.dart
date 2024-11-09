
part of 'user_cubit.dart';
abstract class UserState {}

class UserAuthInitialState extends UserState {}

class UserAuthLoadingState extends UserState {}

class UserAuthSuccessState extends UserState {
 
}

class UserAuthFailureState extends UserState {
  final String message;

  UserAuthFailureState({required this.message});
}
