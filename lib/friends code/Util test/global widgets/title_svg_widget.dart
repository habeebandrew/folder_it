// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// import '../constants.dart';
//
// class TitleSvgWidget extends StatelessWidget {
//   TitleSvgWidget({
//     required this.title,
//     required this.svg,
//     this.iconButton,
//     super.key,
//   });
//   String title;
//   IconButton? iconButton;
//   String svg;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: getHeight(context) * .045,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                   fontWeight: FontWeight.w900,
//                   fontSize: 24,
//                   fontFamily: kSemiBoldFont),
//             ),
//             if (iconButton != null) iconButton!
//           ],
//         ),
//         SizedBox(
//           height: getHeight(context) * .2,
//           child: Center(
//             child: SvgPicture.asset(
//               svg,
//               height: getHeight(context) * .2,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
