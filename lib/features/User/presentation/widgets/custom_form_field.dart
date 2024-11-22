import 'package:flutter/material.dart';

Widget customFormFiled({
  required TextEditingController controller,
  required String label,
  String? Function(String?)? validator,
  bool obscureText=false,
  IconData?prefixIcon
})
=>TextFormField(
  controller: controller,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(prefixIcon),
    enabledBorder: const OutlineInputBorder(),
    border: const OutlineInputBorder(),
    
  ),
  
  validator: validator,
  obscureText: obscureText,
);
