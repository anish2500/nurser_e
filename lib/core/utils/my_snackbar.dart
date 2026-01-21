import 'package:flutter/material.dart';

/// Updated showMySnackBar to handle different types (Success, Error, etc.)
/// while remaining backwards compatible.
void showMySnackBar({
  required BuildContext context,
  required String message,
  Color? color,
  IconData? icon,
  bool isError = false,
  bool isSuccess = false,
  bool isWarning = false,
  bool isInfo = false,
}) {
  // Determine color and icon based on the boolean flags
  Color snackBarColor = color ?? Colors.green;
  IconData snackBarIcon = icon ?? Icons.check_circle_outline_rounded;

  if (isError) {
    snackBarColor = const Color(0xFFD32F2F); // Red
    snackBarIcon = Icons.error_outline_rounded;
  } else if (isSuccess) {
    snackBarColor = const Color(0xFF388E3C); // Green
    snackBarIcon = Icons.check_circle_outline_rounded;
  } else if (isWarning) {
    snackBarColor = const Color(0xFFFFA726); // Orange
    snackBarIcon = Icons.warning_amber_rounded;
  } else if (isInfo) {
    snackBarColor = const Color(0xFF1976D2); // Blue
    snackBarIcon = Icons.info_outline_rounded;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(snackBarIcon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: snackBarColor,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ),
  );
}

// --- Specialized Helper Functions (Optional but recommended for cleaner calls) ---

void showSuccessSnackBar(BuildContext context, String message) {
  showMySnackBar(context: context, message: message, isSuccess: true);
}

void showErrorSnackBar(BuildContext context, String message) {
  showMySnackBar(context: context, message: message, isError: true);
}

void showWarningSnackBar(BuildContext context, String message) {
  showMySnackBar(context: context, message: message, isWarning: true);
}

void showInfoSnackBar(BuildContext context, String message) {
  showMySnackBar(context: context, message: message, isInfo: true);
}