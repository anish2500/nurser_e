import 'package:flutter/material.dart';
import 'package:nurser_e/widgets/my_button.dart';
import 'package:nurser_e/widgets/my_snackbar.dart';

class DisplayScreens extends StatelessWidget {
  const DisplayScreens({super.key});

  @override
  Widget build(BuildContext context) {
    double topContainerHeight = 450;

    double richTextTop = 60;
    double richTextLeft = 30;

    double bottomTextTop = 20;
    double bottomTextLeft = 30;

    double imageOpacity = 0.8;

    final screenWidth = MediaQuery.of(context).size.width;

    final contentWidth = screenWidth - (bottomTextLeft + 30);

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            height: topContainerHeight,
            width: screenWidth,
            child: Stack(
              children: [
                SizedBox(
                  height: topContainerHeight,
                  width: screenWidth,
                  child: Opacity(
                    opacity: imageOpacity,
                    child: Image.asset(
                      'assets/images/backimage.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  top: richTextTop,
                  left: richTextLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'nurser',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 42,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: 'E',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 42,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              width: screenWidth,
              color: Colors.white,

              child: Stack(
                children: [
                  Positioned(
                    top: bottomTextTop,
                    left: bottomTextLeft,
                    child: SizedBox(
                      width: contentWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Hello,',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 6),

                          Text(
                            'Welcome to nurserE',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 40),

                          MyButton(
                            text: "Login",
                            color: const Color.fromARGB(255, 205, 205, 205),
                            onPressed: () {
                              showMySnackBar(
                                context: context,
                                message: "Login Clicked!",
                              );
                            },
                            textStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(
                                255,
                                153,
                                153,
                                153,
                              ), // override default color
                              fontSize: 22, // override default size
                            ),
                          ),

                          SizedBox(height: 30),

                          MyButton(
                            text: "SignUp",
                            color: Colors.green,
                            onPressed: () {
                              showMySnackBar(
                                context: context,
                                message: "SignUp Clicked!",
                              );
                            },
                            textStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // override default color
                              fontSize: 22, // override default size
                            ),
                          ),
                        ],
                      ),
                    ),
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
