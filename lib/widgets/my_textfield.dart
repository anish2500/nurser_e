import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.textStyle,
    this.hintStyle,
    this.fillColor,
    this.contentPadding,
    this.borderRadius,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final EdgeInsets? contentPadding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: textStyle ?? const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: hintStyle ?? const TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xFF9E9E9E),
        ),
        filled: true,
        fillColor: fillColor ?? const Color(0xFFE0E0E0),
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
