// theme/bottom_navigation_theme.dart
import 'package:flutter/material.dart';

BottomNavigationBarThemeData getBottomNavigationTheme() {
  return BottomNavigationBarThemeData(
    backgroundColor: Colors.white,             
    selectedItemColor: Color(0xFF43B925),         
    unselectedItemColor: Colors.grey[500],        
    selectedIconTheme: IconThemeData(size: 22),   
    unselectedIconTheme: IconThemeData(size: 20), 
    selectedLabelStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,                            
      color: Color(0xFF43B925),                    
    ),
    unselectedLabelStyle: TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 12,
      color: Colors.white,                     
    ),
    elevation: 12,                             
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  );
}
