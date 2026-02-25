import 'package:flutter/material.dart';
import 'package:nurser_e/app/theme/app_colors.dart';

class OrderPlaceholderImage extends StatelessWidget {
  final double width;
  final double height;

  const OrderPlaceholderImage({
    super.key,
    this.width = 50,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.local_florist, color: AppColors.primary, size: 24),
    );
  }
}
