import 'package:flutter/material.dart';
import 'package:nurser_e/app/theme/app_colors.dart';

class PlantSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlantSectionHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkTextPrimary
                : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
