import 'package:flutter/material.dart';

class DisplayScreens extends StatelessWidget {
  const DisplayScreens({super.key});

  @override
  Widget build(BuildContext context) {
    // Heights and widths for containers
    double topContainerHeight = 450;
    double bottomContainerHeight = 350;

    // Position of RichText inside the top container
    double richTextTop = 60;
    double richTextLeft = 40;

    //for text below
    double bottomTextTop = 20;
    double bottomTextLeft = 30;

    // For image opacity
    double imageOpacity = 0.8;

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            height: topContainerHeight,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                SizedBox(
                  height: topContainerHeight,
                  width: MediaQuery.of(context).size.width,
                  child: Opacity(
                    opacity: imageOpacity,
                    child: Image.asset(
                      'assets/images/backimage.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // RichText for image
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
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              height: bottomContainerHeight,

              child: Stack(
                children: [
                  Positioned(
                    top: bottomTextLeft,
                    left: bottomTextLeft,
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Hello, \n',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          TextSpan(
                            text: 'Welcome to nurserE',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
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
          ),
        ],
      ),
    );
  }
}
