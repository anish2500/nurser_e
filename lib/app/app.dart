import 'package:flutter/material.dart';
import 'package:nurser_e/features/dashboard/presentation/pages/profile_screen.dart';

import 'package:nurser_e/features/splash/presentation/pages/splash_screens.dart';
import 'package:nurser_e/app/theme/theme_data.dart';

class App extends StatefulWidget {
  const App({super.key});

  static void setThemeMode(ThemeMode themeMode) {
    _AppState? state = _AppState._instance;
    if (state != null) {
      state.setState(() {
        _AppState._themeMode = themeMode;
      });
    }
  }

  static ThemeMode get currentThemeMode => _AppState._themeMode;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  static ThemeMode _themeMode = ThemeMode.system;
  static _AppState? _instance;

  @override
  void initState() {
    super.initState();
    _instance = this;
  }

  @override
  void dispose() {
    _instance = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        // Toggle between light and dark mode on double tap
        final currentMode = App.currentThemeMode;
        final newMode = currentMode == ThemeMode.light 
            ? ThemeMode.dark 
            : ThemeMode.light;
        App.setThemeMode(newMode);
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),
        darkTheme: getApplicationDarkTheme(),
        themeMode: _themeMode,
        home: SplashScreens(),
      ),
    );
  }
}
