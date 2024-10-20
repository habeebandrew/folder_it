import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';

class ElevatedButtonWidget extends StatelessWidget {
  ElevatedButtonWidget(
      {this.color = kPrimaryBlueColor,
      this.border = false,
      this.isSelected = true,
      this.fontFamily = kBoldFont,
      this.fontSize = 16,
      this.title = '',
      this.minHeight = 0.045,
      this.maxHeight = 0.1,
      this.onPressed,
      Key? key})
      : super(key: key);

  Function()? onPressed;
  String title;
  int fontSize;
  String fontFamily;
  Color color;
  bool isSelected;
  bool border;
  double minHeight;
  double maxHeight;

  @override
  Widget build(BuildContext context) {
    double getWidth = MediaQuery.of(context).size.width;
    double getHeight = MediaQuery.of(context).size.height;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        side: BorderSide(
          width: 1.5,
          color: border ? color : Colors.transparent,
        ),
        backgroundColor: border ? Colors.white : color,
        foregroundColor: color == kPrimaryBlueColor
            ? Colors.white60
            : const Color(0xff232323),
        elevation: 0,
        disabledBackgroundColor: kGreyColor,
        animationDuration: const Duration(milliseconds: 250),
        minimumSize: Size(double.infinity, getHeight * minHeight),
        maximumSize: Size(double.infinity, getHeight * maxHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      onPressed: onPressed,
      child: Container(
        height: getHeight * .052,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: fontFamily,
              height: 1.5,
              color: border ? color : Colors.white,
              fontSize: fontSize.toDouble(),
            ),
          ),
        ),
      ),
    );
  }
}

//todo: refactor and use this widget
// class WelcomeElevatedButtonWidget extends StatelessWidget {
//   const WelcomeElevatedButtonWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     double getWidth = MediaQuery.of(context).size.width;
//     double getHeight = MediaQuery.of(context).size.height;
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: kDarkBlueColor,
//         foregroundColor: const Color(0xff232323),
//         elevation: 0,
//         disabledBackgroundColor: kGreyColor,
//         animationDuration: const Duration(milliseconds: 250),
//         minimumSize: Size(double.infinity, getHeight * 0.045),
//         maximumSize: Size(double.infinity, getHeight * 0.1),
//         shape: const RoundedRectangleBorder(
//           borderRadius: kButtonRadius, // <-- Radius
//         ),
//       ),
//       onPressed: () {},
//       child: Container(
//         width: getWidth * .47,
//         height: getHeight * .22,
//         decoration: const BoxDecoration(
//             color: kDarkBlueColor, borderRadius: kBorderRadius),
//         child: Padding(
//           padding:
//               EdgeInsets.symmetric(horizontal: 10, vertical: getHeight * .03),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                   padding: EdgeInsets.only(
//                       left: getWidth * .15, top: getHeight * .025),
//                   child: SvgPicture.asset('assets/images/car.svg')),
//               const Padding(
//                 padding: EdgeInsets.only(left: 10),
//                 child: Text(
//                   "Enter A Car",
//                   style: TextStyle(
//                     color: kBackGroundColor,
//                     fontFamily: kBoldFont,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
