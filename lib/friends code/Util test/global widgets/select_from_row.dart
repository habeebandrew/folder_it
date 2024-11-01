// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart';
// import '../constants.dart';
// import '../requests_params.dart';
//
// class SelectItemFromRowWidget extends StatefulWidget {
//   SelectItemFromRowWidget({
//     super.key,
//     this.value,
//     required this.valueName1,
//     required this.valueName2,
//     this.requestParams,
//     this.onPress1,
//     this.onPress2,
//     this.pageController,
//   });
//
//   bool? value;
//   String valueName1;
//   String valueName2;
//   PageController? pageController;
//   RequestParams? requestParams;
//   Function()? onPress1;
//   Function()? onPress2;
//
//   @override
//   State<SelectItemFromRowWidget> createState() =>
//       _SelectItemFromRowWidgetState();
// }
//
// class _SelectItemFromRowWidgetState extends State<SelectItemFromRowWidget> {
//   late bool value;
//   @override
//   void initState() {
//     value = widget.value ?? true;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             decoration: BoxDecoration(
//                 color:
//                     !value ? Colors.white : kPrimaryBlueColor.withOpacity(.2),
//                 borderRadius: BorderRadius.circular(10)),
//             height: getHeight(context) * .06,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: MaterialButton(
//                 onPressed: () {
//                   setState(() {
//                     value = true;
//                     if (widget.pageController != null) {
//                       widget.pageController!.animateToPage(0,
//                           duration: const Duration(milliseconds: 500),
//                           curve: Curves.easeInOut);
//                     }
//                   });
//                 },
//                 child: Center(
//                     child: Text(
//                   widget.valueName1,
//                   maxLines: 1,
//                   style: TextStyle(
//                       fontFamily: kBoldFont,fontSize: 10,
//                       color: !value ? kGreyColor : kDarkBlueColor),
//                 )),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(
//           width: kIsWeb ? getWidth(context) * .02 : getWidth(context) * .1,
//         ),
//         Expanded(
//             child: Container(
//           decoration: BoxDecoration(
//               color: value ? Colors.white : kPrimaryBlueColor.withOpacity(.2),
//               borderRadius: BorderRadius.circular(10)),
//           height: getHeight(context) * .06,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: MaterialButton(
//               onPressed: () {
//                 setState(() {
//                   value = false;
//                   // if (widget.requestParams != null) {
//                   //   widget.requestParams!.type = HomeRequestType.analysis;
//                   //   context.read<HomeBloc>().add(ChangeToLoadingApiEvent(
//                   //       requestParams: widget.requestParams!));
//                   // }
//                   if (widget.pageController != null) {
//                     widget.pageController!.animateToPage(0,
//                         duration: const Duration(milliseconds: 500),
//                         curve: Curves.easeInOut);
//                   }
//                   if (widget.pageController != null) {
//                     widget.pageController!.animateToPage(1,
//                         duration: const Duration(milliseconds: 500),
//                         curve: Curves.easeInOut);
//                   }
//                 });
//               },
//               child: Center(
//                   child: Text(
//                 widget.valueName2,
//                 maxLines: 1,
//                 style: TextStyle(
//                     color: value ? kGreyColor : kDarkBlueColor,fontSize: 10,
//                     fontFamily: kSemiBoldFont),
//               )),
//             ),
//           ),
//         ))
//       ],
//     );
//   }
// }
