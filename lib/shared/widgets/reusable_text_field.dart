import 'package:flutter/material.dart';

/// A reusable text field widget for user input.
///
/// Example:
/// ```dart
/// ReusableTextField(
///  hintText: 'Enter your name',
///  controller: TextEditingController(),
///  keyboardType: TextInputType.text,
///  inputAction: TextInputAction.next,
///  icon: Icons.person,
///  validator: (value) {
///    if (value == null || value.isEmpty) {
///      return 'Please enter your name';
///    }
///    return null;
///  }
/// ```
class ReusableTextField extends StatelessWidget {
  /// The text to display when the field is empty.
  final String hintText;
  /// The controller to manage the text input.
  final TextEditingController controller;
  /// The type of keyboard to display.
  final TextInputType keyboardType;
  /// The action to perform when the user submits the text.
  final TextInputAction inputAction;
  /// An optional icon to display inside the text field.
  final IconData? icon;
  /// An optional validator function to validate the input.
  final String? Function(String?)? validator;
  /// An optional decoration for the text field.
  final InputDecoration? decoration;
  /// Whether to obscure the text input (for passwords).
  final bool obscureText;
  /// An optional callback function to handle text submission.
  final Function(String)? onSubmitted;

  /// Creates a [ReusableTextField].
  const ReusableTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    required this.inputAction,
    this.icon,
    this.validator,
    this.decoration,
    this.obscureText = false,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
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
        decoration: decoration ??
            InputDecoration(
              prefixIcon: icon != null ? Icon(icon) : null,
              hintText: hintText,
            ),
      ),
    );
  }
}
