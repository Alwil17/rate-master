import 'package:flutter/material.dart';

Widget buildTextField(BuildContext context, {
  required String hintText,
  required TextEditingController controller,
  required TextInputType keyboardType,
  required TextInputAction inputAction,
  IconData? icon,
  String? Function(String?)? validator,
  InputDecoration? decoration,
  bool obscureText = false,
  Function(String)? onSubmitted,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 16),
    child: TextFormField(
      textInputAction: inputAction,
      autofocus: true,
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onFieldSubmitted: onSubmitted,
      decoration: decoration ?? InputDecoration(
        prefixIcon: (icon != null) ? Icon(icon): null,
        hintText: hintText,
      ),
    ),
  );
}