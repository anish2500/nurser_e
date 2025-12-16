import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nurser_e/screens/bottom_navigation_layout.dart';
import 'package:nurser_e/widgets/my_button.dart';
import 'package:nurser_e/widgets/my_textfield.dart';
import 'package:nurser_e/screens/signup_screens.dart';
import 'package:nurser_e/screens/bottom_screens/home_screen.dart';

class LoginScreens extends StatefulWidget {
  const LoginScreens({super.key});

  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: SizedBox(
              width: double.infinity,
              // height: 450,
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 6,
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
                child: SafeArea(
                  top: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Login',
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
                        
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins Regular',
                          color: Colors.grey  
                        ),
                        obscure: false,
                      ),
                      const SizedBox(height: 16),
                      MyTextField(
                        controller: _passwordController,
                        hint: 'Password',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins Regular', 
                          color: Colors.grey
                        ),
                        obscure: true,
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
                              const TextSpan(text: "Don't have an account? "),
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
                      const SizedBox(height: 30),
                      MyButton(
                        text: 'Login',
                        elevation: 4,
                        
                        textStyle: TextStyle(
                          fontFamily: 'Poppins Regular', 
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BottomNavigationLayout(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
