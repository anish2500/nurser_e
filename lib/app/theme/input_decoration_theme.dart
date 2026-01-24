import 'package:flutter/material.dart';
import 'package:nurser_e/app/theme/app_colors.dart';

InputDecorationThemeData getInputDecorationTheme() {
  return InputDecorationThemeData(
      filled: true, 
      fillColor: AppColors.inputFill, 

      labelStyle: const TextStyle(
        fontSize: 14, 
        fontWeight: FontWeight.w500, 
        color: Colors.black87, 
      ),

      hintStyle: TextStyle(fontSize: 12, 
      color: Colors.grey[600]), 

      errorStyle: const TextStyle( fontSize: 10, color: Colors.redAccent),

  );
}

InputDecorationThemeData getDarkInputDecorationTheme() {
  return InputDecorationThemeData(
      filled: true, 
      fillColor: AppColors.darkInputFill, 

      labelStyle: const TextStyle(
        fontSize: 14, 
        fontWeight: FontWeight.w500, 
        color: AppColors.darkTextPrimary, 
      ),

      hintStyle: TextStyle(fontSize: 12, 
      color: AppColors.darkTextSecondary), 

      errorStyle: const TextStyle( fontSize: 10, color: Colors.redAccent),

  );
}
