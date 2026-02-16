import 'package:flutter/material.dart';
import 'package:nurser_e/app/app.dart';
import 'package:nurser_e/features/dashboard/presentation/pages/display_screens.dart';
import 'package:nurser_e/core/widgets/my_button.dart';

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
      subtitle:
          'Sign up effortlessly and start your journey with NurserE in just a few simple steps',
      imagePath: 'assets/images/plant1.jpg',
    ),
    OnboardingData(
      title: 'Professional Care',
      subtitle:
          'Connect with qualified nurses and healthcare professionals for quality care',
      imagePath: 'assets/images/plant2.jpg',
    ),
    OnboardingData(
      title: 'Let\'s Get Started',
      subtitle:
          'Experience seamless healthcare management right at your fingertips',
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
    final isDarkMode = App.currentThemeMode == ThemeMode.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width >= 768 ? 140 : 120,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width >= 768
                        ? 60
                        : 30,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'nurser',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white70 : Colors.grey,
                                fontSize:
                                    MediaQuery.of(context).size.width >= 768
                                    ? 64
                                    : 42,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: 'E',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize:
                                    MediaQuery.of(context).size.width >= 768
                                    ? 64
                                    : 42,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width >= 768
                        ? 60
                        : 30,
                    vertical: MediaQuery.of(context).size.width >= 768
                        ? 30
                        : 20,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[900] : Colors.grey[50],
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
                              color: _currentPage == index
                                  ? Colors.green
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width >= 768
                            ? 40
                            : 30,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_currentPage > 0)
                            SizedBox(
                              width: MediaQuery.of(context).size.width >= 768
                                  ? 120
                                  : 100,
                              child: MyButton(
                                text: 'Back',
                                backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                                height: MediaQuery.of(context).size.width >= 768
                                    ? 48
                                    : 44,
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                textColor: isDarkMode ? Colors.white : Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width >= 768
                                    ? 18
                                    : 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          else
                            SizedBox(
                              width: MediaQuery.of(context).size.width >= 768
                                  ? 120
                                  : 100,
                            ),

                          SizedBox(
                            width: MediaQuery.of(context).size.width >= 768
                                ? 180
                                : 140,
                            child: MyButton(
                              text: _currentPage == _onboardingData.length - 1
                                  ? 'Get Started'
                                  : 'Next',
                              backgroundColor: Colors.green,
                              height: MediaQuery.of(context).size.width >= 768
                                  ? 48
                                  : 44,
                              onPressed: () {
                                if (_currentPage ==
                                    _onboardingData.length - 1) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DisplayScreens(),
                                    ),
                                  );
                                } else {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              textColor: Colors.white,
                              fontSize: MediaQuery.of(context).size.width >= 768
                                  ? 18
                                  : 16,
                              fontWeight: FontWeight.bold,
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
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width >= 768 ? 40 : 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width:
                    constraints.maxWidth *
                    (MediaQuery.of(context).size.width >= 768 ? 0.6 : 0.7),
                height:
                    constraints.maxHeight *
                    (MediaQuery.of(context).size.width >= 768 ? 0.4 : 0.5),
                decoration: BoxDecoration(
                  color: App.currentThemeMode == ThemeMode.dark ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: data.imagePath != null
                      ? Image.asset(
                          data.imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderIcon(context);
                          },
                        )
                      : _buildPlaceholderIcon(context),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width >= 768 ? 40 : 40,
              ),

              Text(
                data.title,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width >= 768 ? 36 : 28,
                  fontWeight: FontWeight.w700,
                  color: App.currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width >= 768 ? 16 : 16,
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width >= 768
                      ? 40
                      : 20,
                ),
                child: Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width >= 768
                        ? 18
                        : 16,
                    fontWeight: FontWeight.w400,
                    color: App.currentThemeMode == ThemeMode.dark ? Colors.white70 : Colors.grey[600],
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

  Widget _buildPlaceholderIcon(BuildContext context) {
    return Center(
      child: Icon(
        Icons.medical_services,
        size: MediaQuery.of(context).size.width >= 768 ? 120 : 80,
        color: Colors.green,
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String? imagePath;

  OnboardingData({required this.title, required this.subtitle, this.imagePath});
}
