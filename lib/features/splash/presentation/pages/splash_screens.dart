import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:nurser_e/app/app.dart';
import 'package:nurser_e/core/services/storage/user_session_service.dart';
import 'package:nurser_e/features/dashboard/presentation/pages/bottom_navigation_layout.dart';
import 'package:nurser_e/features/onboarding/presentation/pages/onboarding_screens.dart';

class SplashScreens extends ConsumerStatefulWidget {
  // Changed to ConsumerStatefulWidget
  const SplashScreens({super.key});

  @override
  ConsumerState<SplashScreens> createState() => _SplashScreensState();
}

class _SplashScreensState extends ConsumerState<SplashScreens> {
  // Changed to ConsumerState
  @override
  void initState() {
    super.initState();
    // Start the navigation timer
    _navigateToNext();
  }

  /// Handles the delayed navigation to the onboarding screen
  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    //check if the user is logged in
    final userSessionService = ref.read(userSessionServiceProvider);
    final isLoggedIn = userSessionService.isLoggedIn();

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavigationLayout()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreens()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: App.currentThemeMode == ThemeMode.dark
          ? Colors.black
          : Colors.white,
      appBar: AppBar(
        backgroundColor: App.currentThemeMode == ThemeMode.dark
            ? Colors.black
            : Colors.white,
        elevation: 0, // Cleaned up shadow for splash feel
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width >= 768 ? 24 : 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  // Changed to SizedBox for slightly better performance
                  width: MediaQuery.of(context).size.width >= 768 ? 200 : 120,
                  height: MediaQuery.of(context).size.width >= 768 ? 200 : 120,
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width >= 768 ? 20 : 10,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'nurser',
                      style: TextStyle(
                        color: App.currentThemeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: MediaQuery.of(context).size.width >= 768
                            ? 64
                            : 42,
                      ),
                    ),
                    TextSpan(
                      text: 'E',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w700,
                        fontSize: MediaQuery.of(context).size.width >= 768
                            ? 64
                            : 42,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
