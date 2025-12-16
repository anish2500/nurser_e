import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nurser_e/screens/login_screens.dart';
import 'package:nurser_e/screens/bottom_screens/home_screen.dart';
import 'package:nurser_e/widgets/my_button.dart';
import 'package:nurser_e/widgets/my_textfield.dart';
import 'package:nurser_e/widgets/my_snackbar.dart';

class SignupScreens extends StatefulWidget {
  const SignupScreens({super.key});

  @override
  State<SignupScreens> createState() => _SignupScreensState();
}

class _SignupScreensState extends State<SignupScreens> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: SizedBox(
              width: double.infinity,
              child: Image.asset(
                'assets/images/signup.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(30, 24, 30, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SignUp',
                      style: TextStyle(
                        fontFamily: 'Poppins Regular',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                      controller: _emailController,
                      hint: 'Email Address',
                      obscure: false,
                      hintStyle: const TextStyle(
                        fontFamily: 'Poppins Regular',
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 16),
                    MyTextField(
                      controller: _passwordController,
                      hint: 'Password',
                      obscure: true,
                      hintStyle: const TextStyle(
                        fontFamily: 'Poppins Regular',
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 16),
                    MyTextField(
                      controller: _confirmPasswordController,
                      hint: 'Confirm Password',
                      obscure: true,
                      hintStyle: const TextStyle(
                        fontFamily: 'Poppins Regular',
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'Poppins Regular',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(
                                text: "Already have an account? "),
                            TextSpan(
                              text: 'Login',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.green,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreens(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    MyButton(
                      elevation: 4,
                      text: 'SignUp',
                      textStyle: TextStyle(
                        fontFamily: 'Poppins Regular', 
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                      onPressed: () {
                        if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          showMySnackBar(
                            context: context,
                            message: 'Passwords do not match!',
                            color: Colors.red,
                          );
                          return;
                        }
                        showMySnackBar(
                          context: context,
                          message: 'SignUp successful!',
                        );
                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                          );
                        });
                      },
                    ),
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
