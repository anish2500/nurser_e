import 'package:flutter/material.dart';
import 'package:nurser_e/screens/display_screens.dart';
// import 'package:nurser_e/screens/splash_screens.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: DisplayScreens(),
    );
  }
}
