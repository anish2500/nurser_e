import 'package:flutter/material.dart';
import 'package:nurser_e/screens/login_screens.dart';
import 'package:nurser_e/screens/home_screen.dart';
import 'package:nurser_e/widgets/my_button.dart';
import 'package:nurser_e/widgets/my_textfield.dart';
import 'package:nurser_e/widgets/my_snackbar.dart';

class SignupScreens extends StatefulWidget {
  const SignupScreens({super.key});

  @override
  State<SignupScreens> createState() => _SignupScreensState();
}

class _SignupScreensState extends State<SignupScreens> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double topFixedHeight = MediaQuery.of(context).size.width >= 768 ? 500.0 : 400.0;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomAvailableHeight = screenHeight - topFixedHeight;
    
    final availableContentHeight = bottomAvailableHeight - 40;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: topFixedHeight,
              width: double.infinity,
              child: ClipRRect(
                child: Image.asset(
                  'assets/images/signup.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width >= 768 ? 60 : 30, 
                  MediaQuery.of(context).size.width >= 768 ? 32 : 20, 
                  MediaQuery.of(context).size.width >= 768 ? 60 : 30, 
                  MediaQuery.of(context).size.width >= 768 ? 32 : 20
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width >= 768 ? 800 : 600
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SignUp',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: MediaQuery.of(context).size.width >= 768 ? 36 : 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width >= 768 ? 20 : 14),
                      MyTextField(
                        controller: _emailController,
                        hint: 'Email Address',
                        obscure: false,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width >= 768 ? 16 : 10),
                      MyTextField(
                        controller: _passwordController,
                        hint: 'Password',
                        obscure: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width >= 768 ? 16 : 10),
                      MyTextField(
                        controller: _confirmPasswordController,
                        hint: 'Confirm Password',
                        obscure: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width >= 768 ? 16 : 10),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: MediaQuery.of(context).size.width >= 768 ? 16 : 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreens(),
                                  ),
                                );
                              },
                              child: Text(
                                'Login',
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
                      SizedBox(height: MediaQuery.of(context).size.width >= 768 ? 20 : 14),
                      MyButton(
                        text: 'SignUp',
                        onPressed: () {
                          if (_passwordController.text != _confirmPasswordController.text) {
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
                                builder: (context) => const HomeScreen(),
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
      ),
    );
  }
}
