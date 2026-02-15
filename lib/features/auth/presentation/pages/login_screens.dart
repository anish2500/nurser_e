import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/app/theme/theme_colors_extension.dart';
import 'package:nurser_e/features/dashboard/presentation/pages/bottom_navigation_layout.dart';
import 'package:nurser_e/core/widgets/my_button.dart';
import 'package:nurser_e/core/widgets/my_textfield.dart';
import 'package:nurser_e/features/auth/presentation/pages/signup_screens.dart';
import 'package:nurser_e/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:nurser_e/features/auth/presentation/state/auth_state.dart';
import 'package:nurser_e/core/utils/my_snackbar.dart';


class LoginScreens extends ConsumerWidget {
  const LoginScreens({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController(); 

    

    

    // Listen to auth state changes
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        showMySnackBar(context: context, message: 'Login successful!');
        Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const BottomNavigationLayout()),
            );
          }
        });
      } else if (next.status == AuthStatus.error) {
        showMySnackBar(
          context: context,
          message: next.errorMessage ?? 'Login failed',
          color: Colors.red,
        );
      }
    });

    void _handleLogin() {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        showMySnackBar(
          context: context,
          message: 'Please fill in all fields',
          color: Colors.red,
        );
        return;
      }

      // Call view model login method
      ref
          .read(authViewModelProvider.notifier)
          .login(email: email, password: password);
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: context.backgroundColor,
      body: Column(
        children: [
          // Header with back button and logo
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              color: context.backgroundColor,
              child: Stack(
                children: [
                  // Back button
                  Positioned(
                    top: 50,
                    left: 20,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: context.textPrimary,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  // Logo and title
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo in green box
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'nurser',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'E',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Welcome back! Please login to continue',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: context.cardShadow,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Poppins Regular',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: _emailController,
                      hint: 'Email Address',
                      obscure: false,
                    ),
                    const SizedBox(height: 8),
                    MyTextField(
                      controller: _passwordController,
                      hint: 'Password',
                      obscure: true,
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Poppins Regular',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: context.textPrimary,
                          ),
                          children: [
                            TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'SignUp',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.green,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SignupScreens(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    MyButton(
                      elevation: 4,
                      text: authState.status == AuthStatus.loading
                          ? 'Logging In...'
                          : 'Login',
                      textStyle: const TextStyle(
                        fontFamily: 'Poppins Regular',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      onPressed: authState.status == AuthStatus.loading
                          ? () {}
                          : _handleLogin,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
