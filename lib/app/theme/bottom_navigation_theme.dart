// theme/bottom_navigation_theme.dart
import 'package:flutter/material.dart';
import 'package:nurser_e/app/theme/app_colors.dart';

BottomNavigationBarThemeData getBottomNavigationTheme() {
  return BottomNavigationBarThemeData(
    backgroundColor: Colors.white,             
    selectedItemColor: AppColors.primary,         
    unselectedItemColor: Colors.grey[500],        
    selectedIconTheme: IconThemeData(size: 22),   
    unselectedIconTheme: IconThemeData(size: 20), 
    selectedLabelStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,                            
      color: AppColors.primary,                    
    ),
    unselectedLabelStyle: TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 12,
      color: Colors.grey[500],                     
    ),
    elevation: 12,                             
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  );
}

BottomNavigationBarThemeData getDarkBottomNavigationTheme() {
  return BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkSurface,             
    selectedItemColor: AppColors.primary,         
    unselectedItemColor: AppColors.darkTextSecondary,        
    selectedIconTheme: IconThemeData(size: 22),   
    unselectedIconTheme: IconThemeData(size: 20), 
    selectedLabelStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,                            
      color: AppColors.primary,                    
    ),
    unselectedLabelStyle: TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 12,
      color: AppColors.darkTextSecondary,                     
    ),
    elevation: 12,                             
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  );
}
