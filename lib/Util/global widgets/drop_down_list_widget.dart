import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class DropDownListWidget extends StatelessWidget {
  DropDownListWidget(
      {this.index = 0,
      required this.dropDownValues,
      required this.onChanged,
      required this.value,
      required this.hint,
       this.fontSize,
      Key? key})
      : super(key: key);

  Function(String?)? onChanged;
  String? value;
  String hint;
  List<String>? dropDownValues;
  int index;
  double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          border: Border.all(color: kGreyColor.withOpacity(.5))),
      child: DropdownButton(
          underline: Container(),
          isExpanded: true,
          dropdownColor: kBackgroundColor,
          focusColor: kGreyColor,
          borderRadius: BorderRadius.circular(10),
          elevation: 0,
          alignment: Alignment.center,
          menuMaxHeight: 225,
          hint: Text(
            hint,
            style: TextStyle(fontFamily: kNormalFont,fontSize: fontSize),
          ),
          style: TextStyle(
            color: kBlackColor,
            // fontFamily: kBoldFont,
              fontFamily: kNormalFont,fontSize: fontSize
          ),
          value: value,
          items: dropDownValues?.map((String items) {
            return DropdownMenuItem(
              alignment: Alignment.center,
              value: items,
              child: Text(
                items,
                style:TextStyle(fontFamily: kNormalFont,fontSize: fontSize),
              ),
            );
          }).toList(),
          onChanged: onChanged),
    );
  }
}
