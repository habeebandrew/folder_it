// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_svg/svg.dart';
//
// import '../constants.dart';
// import 'elevated_button_widget.dart';
//
// class SomethingWrongWidget extends StatelessWidget {
//   SomethingWrongWidget(
//       {this.textColor = kBlackColor,
//       this.title = 'حدث خطأ ما !',
//       this.svgPath = "assets/images/no-internet.svg",
//       this.svgSize = 200,
//       this.elevatedButtonWidget,
//       this.sizedBoxHeight = 50,
//       Key? key})
//       : super(key: key);
//   String title;
//   String svgPath;
//   double sizedBoxHeight;
//   double svgSize;
//   ElevatedButtonWidget? elevatedButtonWidget;
//   Color textColor;
//   @override
//   Widget build(BuildContext context) {
//     double getWidth = MediaQuery.of(context).size.width;
//     double getHeight = MediaQuery.of(context).size.height;
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           SvgPicture.asset(
//             svgPath,
//             height: svgSize,
//             color: kGreyColor.withOpacity(.4),
//           ),
//           SizedBox(
//             height: sizedBoxHeight,
//           ),
//           Builder(builder: (context) {
//             if (title == 'حدث خطأ ما !') {
//               return Text(
//                 title,
//                 style: const TextStyle(
//                   fontFamily: kNormalFont,
//                   color: kBlackColor,
//                   fontSize: 20,
//                 ),
//               );
//             }
//             return Text(
//               title,
//               style: TextStyle(
//                 fontFamily: kNormalFont,
//                 color: textColor,
//                 fontSize:kIsWeb&&mobileMaxWidth > getWidth? 20:11,
//               ),
//             );
//           }),
//           Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: getWidth * 0.2, vertical: getWidth * 0.02),
//             child: elevatedButtonWidget ?? Container(),
//           ),
//         ],
//       ),
//     );
//   }
// }
