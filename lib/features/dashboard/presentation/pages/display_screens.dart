import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/app/theme/theme_colors_extension.dart';
import 'package:nurser_e/features/auth/presentation/pages/login_screens.dart';
import 'package:nurser_e/features/auth/presentation/pages/signup_screens.dart';
import 'package:nurser_e/core/widgets/my_button.dart';
import 'package:nurser_e/core/utils/my_snackbar.dart';

class DisplayScreens extends StatelessWidget {
  const DisplayScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              color: context.surfaceColor,
              child: Center(
                child: Image.asset(
                  'assets/images/back.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              color: context.surfaceColor,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello,',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: context.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Welcome to nurserE',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: context.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Your Green Companion',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 40),

                  MyButton(
                    text: "Login",
                    height: 50,
                    elevation: 2,
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    textColor: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    onPressed: () {
                      showMySnackBar(
                        context: context,
                        message: "Login Clicked!",
                      );

                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProviderScope(
                              child: const LoginScreens(),
                            ),
                          ),
                        );
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  MyButton(
                    text: "SignUp",
                    height: 50,
                    elevation: 2,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    onPressed: () {
                      showMySnackBar(
                        context: context,
                        message: "SignUp Clicked!",
                      );

                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProviderScope(
                              child: const SignupScreens(),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}