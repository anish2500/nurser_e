import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onPressed,
    required this.text,

    // layout
    this.width,
    this.height,
    this.padding,

    // button style
    this.backgroundColor,
    this.elevation,
    this.shape,

    // text style
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.textStyle,
  });

  final VoidCallback onPressed;
  final String text;

  // layout
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  // button style
  final Color? backgroundColor;
  final double? elevation;
  final OutlinedBorder? shape;

  // text style
  final Color? textColor;
  final double? fontSize; // ✅ fixed type
  final FontWeight? fontWeight;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48,
      child: ElevatedButton(
        style: theme.elevatedButtonTheme.style?.copyWith(
              backgroundColor:
                  WidgetStateProperty.all(backgroundColor),
              elevation: WidgetStateProperty.all(elevation),
              padding: WidgetStateProperty.all(
                padding ??
                    const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
              ),
              shape: shape != null
                  ? WidgetStateProperty.all(shape)
                  : null,
            ) ??
            ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              elevation: elevation,
              padding: padding,
              shape: shape,
            ),
        onPressed: onPressed,
        child: Text(
          text,
          style: textStyle ??
              theme.textTheme.labelLarge?.copyWith(
                color: textColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
        ),
      ),
    );
  }
}
