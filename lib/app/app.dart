import 'package:flutter/material.dart';
import 'package:nurser_e/features/dashboard/presentation/pages/about_screen.dart';

import 'package:nurser_e/features/splash/presentation/pages/splash_screens.dart';


import 'package:nurser_e/app/theme/theme_data.dart';

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
