import 'package:flutter/material.dart';
import 'package:nurser_e/app/theme/app_colors.dart';

class OrderStatusChip extends StatelessWidget {
  final String? status;

  const OrderStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (status) {
      case 'confirmed':
        statusColor = AppColors.success;
        statusText = 'Confirmed';
        break;
      case 'shipped':
        statusColor = Colors.blue;
        statusText = 'Shipped';
        break;
      case 'delivered':
        statusColor = AppColors.success;
        statusText = 'Delivered';
        break;
      case 'cancelled':
        statusColor = AppColors.error;
        statusText = 'Cancelled';
        break;
      default:
        statusColor = Colors.orange;
        statusText = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
