// part of 'user_bloc.dart';
//
// abstract class UserEvent {}
//
// class LoginEvent extends UserEvent {
//   LoginEvent({required this.email, required this.password});
//   String email;
//   String password;
// }
//
// class NewPasswordEvent extends UserEvent {
//   NewPasswordEvent(
//       {required this.phone,
//       required this.code,
//       required this.password,
//       required this.phoneCode});
//   String phone;
//   String phoneCode;
//   String code;
//   String password;
// }
//
// class VerifyEvent extends UserEvent {
//   VerifyEvent(
//       {required this.phone,
//       required this.code,
//       required this.verificationCode});
//   String phone;
//   String verificationCode;
//   String code;
// }
//
// class NotifiableActionEvent extends UserEvent {
//   NotifiableActionEvent(
//       {required this.action});
//   int action;
// }
//
// class VerifyToChangePasswordEvent extends UserEvent {
//   VerifyToChangePasswordEvent(
//       {required this.phone,
//       required this.code,
//       required this.verificationCode});
//   String phone;
//   String verificationCode;
//   String code;
// }
//
// class RegisterEvent extends UserEvent {
//   RegisterEvent(
//       {required this.email,
//       required this.password,
//       required this.name,
//       });
//   String name;
//   String email;
//   String password;
//
// }
//
// class CheckTokenEvent extends UserEvent {}
//
// class ResendCodeEvent extends UserEvent {
//   ResendCodeEvent({required this.phoneCode, required this.phone});
//   String phone;
//   String phoneCode;
// }
//
// class SendCodeEvent extends UserEvent {
//   SendCodeEvent({required this.phoneCode, required this.phone});
//   String phone;
//   String phoneCode;
// }
//
// class GetMyProfile extends UserEvent {}
//
// class ChangePasswordEvent extends UserEvent {
//   ChangePasswordEvent({required this.newPassword, required this.oldPassword});
//   String oldPassword;
//   String newPassword;
// }
//
// class LogOutEvent extends UserEvent {
//   LogOutEvent({required this.deleteAccount});
//   bool deleteAccount;
// }
//
// class SaveUserToLocalStorageEvent extends UserEvent {
//   SaveUserToLocalStorageEvent({required this.userModel});
//   WelcomeUser userModel;
// }
//
// class AddFcmToken extends UserEvent {}
// class ContinueAsGuest extends UserEvent {}
