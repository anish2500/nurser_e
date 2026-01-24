import 'package:flutter/material.dart';
import 'package:nurser_e/app/theme/theme_colors_extension.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SizedBox.expand(
        child: Center(
          child: Text(
            "This is categories screen",
            style: TextStyle(
              color: context.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
