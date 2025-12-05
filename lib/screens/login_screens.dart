import 'package:flutter/material.dart';
import 'package:nurser_e/widgets/my_button.dart';
import 'package:nurser_e/widgets/my_textfield.dart';
import 'package:nurser_e/widgets/my_snackbar.dart';
import 'package:nurser_e/screens/signup_screens.dart';
import 'package:nurser_e/screens/home_screen.dart';

class LoginScreens extends StatefulWidget {
  const LoginScreens({super.key});

  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double topHeight = MediaQuery.of(context).size.width >= 768 ? 500.0 : 425.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: topHeight,
            width: double.infinity,
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width >= 768 ? 60 : 30, 
                MediaQuery.of(context).size.width >= 768 ? 32 : 24, 
                MediaQuery.of(context).size.width >= 768 ? 60 : 30, 
                MediaQuery.of(context).size.width >= 768 ? 32 : 24
              ),
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
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: MediaQuery.of(context).size.width >= 768 ? 36 : 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width >= 768 ? 24 : 20),
                    MyTextField(
                      controller: _emailController,
                      hint: 'Email Address',
                      obscure: false,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width >= 768 ? 20 : 16),
                    MyTextField(
                      controller: _passwordController,
                      hint: 'Password',
                      obscure: true,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width >= 768 ? 16 : 12),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: MediaQuery.of(context).size.width >= 768 ? 16 : 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupScreens(),
                                ),
                              );
                            },
                            child: Text(
                              'SignUp',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: MediaQuery.of(context).size.width >= 768 ? 16 : 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    MyButton(
                      text: 'Login',
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
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
