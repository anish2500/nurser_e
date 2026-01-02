import 'package:flutter/material.dart';

InputDecorationThemeData getInputDecorationTheme() {
  return InputDecorationThemeData(
      filled: true, 
      fillColor: Colors.grey.shade50, 


      labelStyle: const TextStyle(
        fontSize: 14, 
        fontWeight: FontWeight.w500, 
        color: Colors.black, 

      ),

      hintStyle: TextStyle(fontSize: 12, 
      color: Colors.grey.shade500), 

      errorStyle: const TextStyle( fontSize: 10, color: Colors.redAccent),


  );
}
