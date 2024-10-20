// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:internet_applications/Presentaion/Bottom%20Nav%20Screen/widgets/bottom_nav_bar.dart';
// import 'package:internet_applications/Presentaion/Bottom%20Nav%20Screen/widgets/nav_rail.dart';
//
// import '../../BusinessLogic/Reports Bloc/reports_bloc.dart';
// import '../../BusinessLogic/user_bloc/user_bloc.dart';
// import '../../Util/constants.dart';
// import '../../Util/global widgets/dialogs_widgets.dart';
// import '../../Util/requests_params.dart';
// import '../../Util/responsive_view.dart';
// import '../Home Screen/home_screen.dart';
// import '../Reports Screen/reports_screen.dart';
//
// class BottomNavScreen extends StatefulWidget {
//   BottomNavScreen({Key? key, this.currentIndex}) : super(key: key);
//   int? currentIndex;
//   @override
//   State<BottomNavScreen> createState() => _BottomNavScreenState();
// }
//
// class _BottomNavScreenState extends State<BottomNavScreen>
//     with SingleTickerProviderStateMixin {
//   bool groupsSelected = false;
//   late int _currentIndex;
//   final PageController _pageController = PageController();
//   late Animation<double> _animation;
//   late AnimationController _animationController;
//   RequestParams requestParams = RequestParams();
//   @override
//   void initState() {
//     _currentIndex = widget.currentIndex ?? 0;
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 260),
//     );
//
//     final curvedAnimation =
//         CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
//     _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _pageController.dispose();
//     _animationController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final userState = context.read<UserBloc>().state;
//     return ScaffoldMessenger(
//       child: Scaffold(
//         backgroundColor: kBackgroundColor,
//         bottomNavigationBar: ResponsiveView(
//           mobile: (_, __) => BottomNavBarWidget(
//             selectedPage: _currentIndex,
//             onPressed: (index) {
//               setState(() {
//                 _currentIndex = index;
//               });
//             },
//           ),
//           desktop: (double height, double width) {
//             return Row(
//               children: [
//                 BlocProvider(
//                     create: (context) => UserBloc(),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(5),
//                           topRight: Radius.circular(5),
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.16),
//                             blurRadius: 4,
//                             offset: const Offset(0, -2),
//                           )
//                         ],
//                       ),
//                       child: ClipRRect(
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(5),
//                           topRight: Radius.circular(5),
//                         ),
//                         child: SingleChildScrollView(
//                           child: ConstrainedBox(
//                             constraints: BoxConstraints(
//                                 minHeight: MediaQuery.of(context).size.height),
//                             child: Container(
//                               color: kDarkBlueColor,
//                               child: Column(
//                                 children: [
//                                   const Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       Text(
//                                         "Internet Application",
//                                         style: TextStyle(
//                                             fontSize: 10,
//                                             fontFamily: kBoldFont,
//                                             color: kDarkBlueColor),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     width: 230,
//                                     child: ListView(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: getHeight(context) * .04,
//                                           horizontal: getWidth(context) * .01),
//                                       shrinkWrap: true,
//                                       physics:
//                                           const NeverScrollableScrollPhysics(),
//                                       children: [
//                                         MaterialButton(
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: 10),
//                                           onPressed: () {
//                                             setState(() {
//                                               _currentIndex = 0;
//                                             });
//                                           },
//                                           child: ListTile(
//                                             onTap: null,
//                                             tileColor: _currentIndex == 0
//                                                 ? Colors.white
//                                                 : kDarkBlueColor,
//                                             leading: Icon(
//                                               Icons.home,
//                                               color: _currentIndex == 0
//                                                   ? kDarkBlueColor
//                                                   : Colors.white,
//                                             ),
//                                             title: Text(
//                                               'Home',
//                                               style: TextStyle(
//                                                   fontSize: 11,
//                                                   color: _currentIndex == 0
//                                                       ? kDarkBlueColor
//                                                       : Colors.white,
//                                                   fontFamily: kNormalFont),
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           height: 10,
//                                         ),
//                                         MaterialButton(
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: 10),
//                                           onPressed: () {
//                                             setState(() {
//                                               _currentIndex = 1;
//                                             });
//                                           },
//                                           child: ListTile(
//                                             onTap: null,
//                                             tileColor: _currentIndex == 1
//                                                 ? Colors.white
//                                                 : kDarkBlueColor,
//                                             leading: Icon(
//                                               Icons.event_note_sharp,
//                                               color: _currentIndex == 1
//                                                   ? kDarkBlueColor
//                                                   : Colors.white,
//                                             ),
//                                             title: Text(
//                                               'Reports',
//                                               style: TextStyle(
//                                                   fontSize: 10,
//                                                   color: _currentIndex == 1
//                                                       ? kDarkBlueColor
//                                                       : Colors.white,
//                                                   fontFamily: kNormalFont),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: getHeight(context) - 250,
//                                         ),
//                                         MaterialButton(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 10),
//                                             onPressed: () {
//                                               DialogsWidgets
//                                                   .showLogoutDeleteAccountDialog(
//                                                       context: context,
//                                                       isDeleteAccount: false);
//                                             },
//                                             child: ListTile(
//                                                 tileColor: kDarkBlueColor,
//                                                 onTap: null,
//                                                 leading: const Icon(
//                                                   Icons.logout,
//                                                   color: Colors.white,
//                                                 ),
//                                                 title: BlocBuilder<UserBloc,
//                                                     UserState>(
//                                                   builder: (context, state) =>
//                                                       const Text(
//                                                     'Logout',
//                                                     style: TextStyle(
//                                                         fontSize: 10,
//                                                         color: Colors.white,
//                                                         fontFamily:
//                                                             kNormalFont),
//                                                   ),
//                                                 ))),
//                                         const SizedBox(
//                                           height: 90,
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )),
//                 Expanded(
//                   child: webScreen(
//                       index: _currentIndex, requestParams: requestParams),
//                 ),
//               ],
//             );
//           },
//         ),
//         body: kIsWeb && mobileMaxWidth < getWidth(context)
//             ? webScreen(index: _currentIndex, requestParams: requestParams)
//             : screen(index: _currentIndex, requestParams: requestParams),
//       ),
//     );
//   }
//
//   Widget screen({required int index, required RequestParams requestParams}) {
//     return const SizedBox();
//   }
// }
//
// Widget webScreen({required int index, required RequestParams requestParams}) {
//   switch (index) {
//     case 0:
//       return const HomeScreen();
//     case 1:
//       return BlocProvider(
//         create: (context) =>
//             ReportsBloc()..add(GetReportEvent(requestParams: RequestParams())),
//         child: ReportsScreen(),
//       );
//   }
//   return const SizedBox();
// }
