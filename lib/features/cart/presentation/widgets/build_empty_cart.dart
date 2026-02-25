


import 'package:flutter/material.dart';
import 'package:nurser_e/app/theme/app_colors.dart';
import 'package:nurser_e/app/theme/theme_colors_extension.dart';

class BuildEmptyCart extends StatelessWidget {
  const BuildEmptyCart({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add plants to get started',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
