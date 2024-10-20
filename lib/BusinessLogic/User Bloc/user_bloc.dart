import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_applications/BusinessLogic/user_bloc/user_service.dart';
import '../../Data/user_model.dart';
import '../../Util/constants.dart';
import '../../Util/enums.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService _userService = UserService();

  UserBloc() : super(UserNotLoggedState()) {

    on<LoginEvent>((event, emit) async {
      emit(UserLoadingState());
      final userObject = await _userService.loginUserService(
          email: event.email, password: event.password);
      if (userObject is String) {
        emit(UserErrorState(error: userObject));
        return;
      }
      if (userObject is WelcomeUser) {
        await saveUserToLocalStorage(userObject);
        await saveTokenToLocalStorage(userObject.token);
        String? token = await getTokenFromLocalStorage();
        print(token);
        emit(UserSuccessState(user: userObject));
      }  else {
        emit(UserErrorState(error: userObject.toString()));
      }
    });

    on<GetMyProfile>((event, emit) async {
      emit(UserLoadingState());
      final userObject = await _userService.getMyProfileService();
      if (userObject is String) {
        emit(UserErrorState(error: userObject));
        return;
      }
      if (userObject == ServicesResponseStatues.unauthorized) {
        emit(UserNotLoggedState());
        return;
      }
      if (userObject is WelcomeUser) {
        emit(UserSuccessState(user: userObject));
      } else if (userObject == ServicesResponseStatues.networkError) {
        emit(UserErrorState(error: "تحقق من اتصالك بالانترنت"));
      } else {
        emit(UserErrorState(error: userObject.toString()));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(UserLoadingState());
      final userObject = await _userService.registerService(
          email: event.email, password: event.password, name: event.name);
      if (userObject is String) {
        emit(UserErrorState(error: userObject));
        return;
      }
      if (userObject is WelcomeUser) {
        await saveUserToLocalStorage(userObject);
        await saveTokenToLocalStorage(userObject.token);
        emit(UserSuccessState(user: userObject));
      } else if (userObject == ServicesResponseStatues.networkError) {
        emit(UserErrorState(error: "check your internet connection"));
      } else {
        emit(UserErrorState(error: userObject.toString()));
      }
    });

    on<CheckTokenEvent>((event, emit) async {
      WelcomeUser? user = await getUserFromLocalStorage();
      print(user);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (user != null) {
        emit(UserSuccessState(user: user));
      } else {
        emit(UserNotLoggedState());
      }
    });

    on<LogOutEvent>((event, emit) async {
      emit(UserLoadingState());
        await _userService.Logout();
        await deleteFromLocal();
        globalNavigatorKey.currentState
            ?.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        emit(UserNotLoggedState());
    });
  }
}
