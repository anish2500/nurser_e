import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/app/theme/theme_colors_extension.dart';
import 'package:nurser_e/features/auth/presentation/pages/login_screens.dart';
import 'package:nurser_e/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:nurser_e/features/auth/presentation/state/auth_state.dart';
import 'package:nurser_e/core/widgets/my_button.dart';
import 'package:nurser_e/core/widgets/my_textfield.dart';
import 'package:nurser_e/core/utils/my_snackbar.dart';

class SignupScreens extends ConsumerStatefulWidget {
  const SignupScreens({super.key});

  @override
  ConsumerState<SignupScreens> createState() => _SignupScreensState();
}

class _SignupScreensState extends ConsumerState<SignupScreens> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showMySnackBar(
        context: context,
        message: 'Please fill in all fields',
        color: Colors.red,
      );
      return;
    }

    if (password != confirmPassword) {
      showMySnackBar(
        context: context,
        message: 'Passwords do not match!',
        color: Colors.red,
      );
      return;
    }

    // Use email as username for registration
    final username = email.split('@')[0];

    // Call view model register method
    ref
        .read(authViewModelProvider.notifier)
        .register(email: email, username: username, password: password);
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreens()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    // Listen to auth state changes
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.registered) {
        showMySnackBar(
          context: context,
          message: 'SignUp successful! Please login to continue.',
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreens()),
            );
          }
        });
      } else if (next.status == AuthStatus.error) {
        showMySnackBar(
          context: context,
          message: next.errorMessage ?? 'Registration failed',
          color: Colors.red,
        );
      }
    });
    return Scaffold(
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
                          'Register',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your account to get started',
                          style: TextStyle(
                            fontSize: 18,
                            color: context.textSecondary,
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
                      'SignUp',
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
                    const SizedBox(height: 8),
                    MyTextField(
                      controller: _confirmPasswordController,
                      hint: 'Confirm Password',
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
                            TextSpan(text: "Already have an account? "),
                            TextSpan(
                              text: 'Login',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.green,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _navigateToLogin();
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
                          ? 'Signing Up...'
                          : 'SignUp',
                      textStyle: TextStyle(
                        fontFamily: 'Poppins Regular',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      onPressed: authState.status == AuthStatus.loading
                          ? () => {}
                          : _handleSignup,
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
