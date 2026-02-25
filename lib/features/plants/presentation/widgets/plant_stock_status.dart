import 'package:flutter/material.dart';
import 'package:nurser_e/app/theme/app_colors.dart';

class PlantStockStatus extends StatelessWidget {
  final int stock;

  const PlantStockStatus({
    super.key,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    final bool isInStock = stock > 0;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isInStock
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isInStock
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isInStock
                  ? AppColors.success.withValues(alpha: 0.2)
                  : AppColors.error.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isInStock ? Icons.check_circle : Icons.cancel,
              color: isInStock ? AppColors.success : AppColors.error,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isInStock ? 'In Stock' : 'Out of Stock',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isInStock ? AppColors.success : AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isInStock
                      ? '$stock items available'
                      : 'Currently unavailable',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
