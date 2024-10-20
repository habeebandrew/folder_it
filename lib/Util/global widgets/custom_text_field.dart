import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class CustomTextField extends StatelessWidget {
  Color hintColor;
  String? hintText;
  String? labelText;
  EdgeInsets? contentPadding;
  IconData? icon;
  TextInputType? textInputType;
  double? fontSize;
  TextEditingController? controller2;
  String? Function(String?)? validator;
  IconData? icon2;
  Function()? secureText;
  bool onlyNumber;
  List<TextInputFormatter>?inputFormats;
  bool passwordBool;
  Function(String)? onChanged;
  Function(String)? onSubmit;
  Function()? onTap;
  bool enabled;
  bool expands;
  bool date;
  bool withValidationText;
  bool autoFucos;
  bool coloredDisabledText;
  String fontFamily;
  int? maxLength;
  TextInputAction action;
  TextAlign? textAlign;
  int? maxLines;
  int? minLines;
  Widget? suffixIcon;
  CustomTextField({
    this.action = TextInputAction.done,
    this.hintText,
    this.fontFamily=kNormalFont,
    this.inputFormats,
    this.labelText,
    this.contentPadding,
    this.textAlign,
    this.expands = false,
    this.date = false,
    this.coloredDisabledText = true,
    this.onChanged,
    this.hintColor = kHintColor,
    this.autoFucos = false,
    this.suffixIcon,
    this.withValidationText = false,
    this.icon,
    this.textInputType,
    this.fontSize,
    this.controller2,
    this.validator,
    this.icon2,
    this.secureText,
    required this.passwordBool,
    this.onlyNumber = false,
    this.onSubmit,
    this.onTap,
    this.enabled = true,
    this.maxLength,
    this.maxLines,
    this.minLines,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: minLines,
      expands: expands,
      autofocus: autoFucos,
      maxLines: maxLines,
      enabled: enabled,
      onFieldSubmitted: onSubmit,
      onTap: onTap,
      onChanged: onChanged,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
          color: date || enabled||(!enabled && !coloredDisabledText) ? Colors.black87 : kDarkBlueColor,fontFamily: enabled?fontFamily:kBoldFont,
          fontSize: fontSize ?? 14),
      inputFormatters:inputFormats ?? (onlyNumber
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(maxLength),
            ]
          : <TextInputFormatter>[
              LengthLimitingTextInputFormatter(maxLength),
            ]),
      validator: validator,
      controller: controller2,
      obscureText: passwordBool,
      keyboardType: textInputType,
      cursorColor: Colors.black38,
      decoration: InputDecoration(
        // isDense: true,
        // errorMaxLines: 1,
        // errorText: '',
        errorStyle: const TextStyle(
          fontFamily: kNormalFont ,
          // color: Colors.transparent,
          fontSize: 8,
        ),

        suffixIcon: suffixIcon,
        contentPadding: contentPadding ??
            const EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 15),
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(
            color: Colors.black, fontFamily: kLightFont, fontSize: 14),
        hintStyle: TextStyle(
            color: hintColor,
            fontFamily: kNormalFont,
            fontSize: fontSize ?? 14),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
            borderRadius: kRegularBorderRadius,
            borderSide: BorderSide(
              color: kGreyColor.withOpacity(.5),
            )),
        disabledBorder: OutlineInputBorder(
            borderRadius: kRegularBorderRadius,
            borderSide: BorderSide(
              color: kGreyColor.withOpacity(.5),
            )),
        enabled: enabled,
        focusedBorder: const OutlineInputBorder(
            borderRadius: kRegularBorderRadius,
            borderSide: BorderSide(
              width: 2,
              color: kPrimaryBlueColor,
            )),
        border: const OutlineInputBorder(
            borderRadius: kRegularBorderRadius,
            borderSide: BorderSide(
              color: Colors.black,
            )),
      ),
      textInputAction: action,
    );
  }
}
