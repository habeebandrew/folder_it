import 'package:flutter/cupertino.dart';

double getWidth(BuildContext context) => MediaQuery.of(context).size.width;
double getHeight(BuildContext context) => MediaQuery.of(context).size.height;

const kNormalFont = "PoppinsR";
const kLightFont = "PoppinsL";
const kBoldFont = "PoppinsB";
const kSemiBoldFont = "PoppinsSB";
const kItalicBoldFont = "PoppinsI";
const kMediumFont = "PoppinsM";

const Color kBlackColor = Color(0xff000000);

const kHintColor = Color(0xffbdbdbd);
const Color kPrimaryBlueColor = Color(0xff1C6EB9);
const Color kDarkBlueColor = Color(0xff12518B);
const Color kRedColor = Color(0xffDC271E);
const Color kYellowColor = Color(0xffFEB74F);
const Color kBackgroundColor = Color(0xffF2F2F2);
const Color kGreyColor = Color(0xffA6A6A6);
const Color kBorderColor = Color(0xffE0E0E0);
const Color kNotSelectedColor = Color(0xFF666666);

const kRegularBorderRadius = BorderRadius.all(Radius.circular(15));
const kCircularBorderRadius = BorderRadius.all(Radius.circular(20));

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();


const double mobileMaxWidth = 700;
const double tabMaxWidth = 1000;
