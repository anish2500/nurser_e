import 'package:flutter/material.dart';
import 'package:nurser_e/screens/display_screens.dart';
import 'package:nurser_e/widgets/my_button.dart';

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({super.key});

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: 'Easy Register',
      subtitle: 'Sign up effortlessly and start your journey with NurserE in just a few simple steps',
      imagePath: 'assets/images/plant1.jpg',
    ),
    OnboardingData(
      title: 'Professional Care',
      subtitle: 'Connect with qualified nurses and healthcare professionals for quality care',
      imagePath: 'assets/images/plant2.jpg',
    ),
    OnboardingData(
      title: 'Let\'s Get Started',
      subtitle: 'Experience seamless healthcare management right at your fingertips',
      imagePath: 'assets/images/plant3.jpg',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
               
                Container(
                  height: 120,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
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
                    ],
                  ),
                ),

               
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return OnboardingPage(data: _onboardingData[index]);
                    },
                  ),
                ),

             
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _onboardingData.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index ? Colors.green : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                    
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                         
                          if (_currentPage > 0)
                            SizedBox(
                              width: 100,
                              child: MyButton(
                                text: 'Back',
                                color: Colors.grey[300]!,
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                textStyle: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          else
                            const SizedBox(width: 100), 

                         
                          SizedBox(
                            width: 140,
                            child: MyButton(
                              text: _currentPage == _onboardingData.length - 1 ? 'Get Started' : 'Next',
                              color: Colors.green,
                              onPressed: () {
                                if (_currentPage == _onboardingData.length - 1) {
                                  
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DisplayScreens(),
                                    ),
                                  );
                                } else {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              textStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
              Container(
                width: constraints.maxWidth * 0.7,
                height: constraints.maxHeight * 0.5,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: data.imagePath != null
                      ? Image.asset(
                          data.imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderIcon();
                          },
                        )
                      : _buildPlaceholderIcon(),
                ),
              ),
              const SizedBox(height: 40),
              
             
              Text(
                data.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
             
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaceholderIcon() {
    return const Center(
      child: Icon(
        Icons.medical_services,
        size: 80,
        color: Colors.green,
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String? imagePath;

  OnboardingData({
    required this.title,
    required this.subtitle,
    this.imagePath,
  });
}
