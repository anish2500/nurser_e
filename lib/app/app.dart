import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/features/splash/presentation/pages/splash_screens.dart';
import 'package:nurser_e/app/theme/theme_data.dart';
import 'package:nurser_e/core/services/shake_service.dart';
import 'package:nurser_e/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:nurser_e/features/auth/presentation/pages/login_screens.dart';


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

class _AppState extends State<App> with WidgetsBindingObserver {
  static ThemeMode _themeMode = ThemeMode.system;
  static _AppState? _instance;
  late ShakeService _shakeService;
  bool _shakeTriggered = false;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _instance = this;
    _shakeService = ShakeService();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startShakeListener();
    });
  }

  

  void _startShakeListener() {
    _shakeService.startListening(() {
      print('Shake detected - triggering logout');
      if (!_shakeTriggered) {
        _shakeTriggered = true;
        _handleShakeLogout();
      }
    });
  }

  Future<void> _handleShakeLogout() async {
    final container = ProviderScope.containerOf(context);
    await container.read(authViewModelProvider.notifier).logout();

    if (mounted && _navigatorKey.currentState != null) {
      _navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreens()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _shakeService.dispose();
    _instance = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _shakeTriggered = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        final currentMode = App.currentThemeMode;
        final newMode = currentMode == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light;
        App.setThemeMode(newMode);
      },
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),
        darkTheme: getApplicationDarkTheme(),
        themeMode: _themeMode,
        home: Stack(
          children: [
            const SplashScreens(),
          ],
        ),
      ),
    );
  }
}
