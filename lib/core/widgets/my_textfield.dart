import 'package:flutter/material.dart';

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
  bool _showPasswordToggle = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
    _showPasswordToggle = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        style: widget.textStyle ?? const TextStyle(
          fontFamily: 'Poppins Regular',
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: widget.hintStyle ?? const TextStyle(
            fontFamily: 'Poppins Regular',
            color: Color(0xFF9E9E9E),
          ),
          filled: true,
          fillColor: widget.fillColor ?? const Color(0xFFF5F5F5),
          contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.green.shade400,
              width: 2,
            ),
          ),
          suffixIcon: _showPasswordToggle
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey.shade600,
                    size: 20,
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
