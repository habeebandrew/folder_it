import 'package:flutter/material.dart';

const double phoneWidth = 650.0;
const double tabletWidth = 1000.0;
class ResponsiveView extends StatelessWidget {

  final Widget Function(double hight, double width) mobile;
  final Widget Function(double hight, double width)? tablet;
  final Widget Function(double hight, double width) desktop;

  const ResponsiveView({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });
//!
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < phoneWidth) {
      return mobile(MediaQuery.of(context).size.height,
          MediaQuery.of(context).size.width);
    } else if (MediaQuery.of(context).size.width < tabletWidth &&
        tablet != null) {
      return tablet!(MediaQuery.of(context).size.height,
          MediaQuery.of(context).size.width);
    } else {
      return desktop(MediaQuery.of(context).size.height,
          MediaQuery.of(context).size.width);
    }
  }
}
