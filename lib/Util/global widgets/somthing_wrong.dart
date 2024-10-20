import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';

class SomethingWentWrongWidget extends StatelessWidget {
  SomethingWentWrongWidget({
    required this.text,
    this.height,
    required this.svg,
    super.key,
  });
  double? height;
  String text;
  String svg;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(svg),
          SizedBox(
            height: getHeight(context) * .05,
          ),
          Text(
            text,
            style: const TextStyle(
                fontSize: 15, fontFamily: kSemiBoldFont, color: Colors.black54),
          )
        ],
      ),
    );
  }
}
