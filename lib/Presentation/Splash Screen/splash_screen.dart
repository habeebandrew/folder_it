// import 'dart:developer';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../../BusinessLogic/user_bloc/user_bloc.dart';
// import '../../Util/constants.dart';
// import '../../Util/global widgets/dialogs_widgets.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     context.read<UserBloc>().add(CheckTokenEvent());
//     log("posted");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: BlocListener<UserBloc, UserState>(
//       listener: (context, state) {
//         if (state is UserErrorState) {
//           DialogsWidgets.showScaffoldSnackBar(
//               title: state.error, context: context);
//         }
//         if (state is UserSuccessState) {
//           Navigator.pushReplacementNamed(context, '/bottom_nav');
//         }
//         if (state is UserNotLoggedState) {
//           Navigator.pushReplacementNamed(context, '/auth');
//         }
//       },
//       child: Stack(
//         children: [
//           SizedBox(
//             height: getHeight(context),
//             width: getWidth(context),
//             child: Image.asset(
//               kIsWeb && mobileMaxWidth < getWidth(context)
//                   ? "assets/images/web_login_background.png"
//                   : "assets/images/login_background.png",
//               fit: BoxFit.fill,
//             ),
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: getHeight(context) * .08),
//               child: Container(
//                   decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
//                   child: Image.asset("assets/images/Cloudy logo.png",height: getHeight(context)*.5,)),
//             ),
//           ),
//         ],
//       ),
//     ));
//   }
// }
