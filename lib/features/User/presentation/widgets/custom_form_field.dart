import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget customFormFiled({
  required TextEditingController controller,
  required String label,
  String? Function(String?)? validator,
  bool obscureText=false,
})
=>TextFormField(
  controller: controller,
  decoration: InputDecoration(labelText: label),
  validator: validator,
  obscureText: obscureText,
);
