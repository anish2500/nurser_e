import 'package:flutter/material.dart';
import 'package:nurser_e/screens/login_screens.dart';
import 'package:nurser_e/screens/signup_screens.dart';
import 'package:nurser_e/widgets/my_button.dart';
import 'package:nurser_e/widgets/my_snackbar.dart';

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
              color: Colors.white,
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
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hello,',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Welcome to nurserE',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 50,),

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
                            builder: (_) => const LoginScreens(),
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
                            builder: (_) => const SignupScreens(),
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
