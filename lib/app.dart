import 'package:flutter/material.dart';
import 'package:nurser_e/screens/bottom_navigation_layout.dart';
import 'package:nurser_e/screens/display_screens.dart';
import 'package:nurser_e/screens/login_screens.dart';
import 'package:nurser_e/screens/signup_screens.dart';
import 'package:nurser_e/screens/splash_screens.dart';
// import 'package:nurser_e/screens/display_screens.dart';
import 'package:nurser_e/theme/theme_data.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: SplashScreens(),
    );
  }
}
