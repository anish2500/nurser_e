import 'package:flutter/material.dart';
import 'package:nurser_e/app/theme/theme_colors_extension.dart';

class MyTextField extends StatefulWidget {
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
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        style: widget.textStyle ?? TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: context.isDarkMode ? context.textPrimary : Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: widget.hintStyle ?? TextStyle(
            fontFamily: 'Poppins',
            color: context.isDarkMode ? context.textSecondary : Colors.grey[600],
          ),
          filled: true,
          fillColor: widget.fillColor ?? context.inputFillColor,
          contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(25),
            borderSide: BorderSide(
              color: _isFocused ? Colors.green : Colors.transparent,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(25),
            borderSide: BorderSide(
              color: _isFocused ? Colors.green : Colors.transparent,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: Colors.green,
              width: 2,
            ),
          ),
          suffixIcon: widget.obscure
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: context.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
