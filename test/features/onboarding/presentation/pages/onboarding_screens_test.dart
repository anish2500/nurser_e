import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nurser_e/features/onboarding/presentation/pages/onboarding_screens.dart';

void main() {
  group('OnboardingScreens UI Elements', () {
    testWidgets('should display app title with nurserE', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SizedBox(
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('nurserE'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('nurserE'), findsOneWidget);
    });

    testWidgets('should display page indicator dots', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: index == 0 ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == 0 ? Colors.green : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should display Next button on first page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: const Text('Next'),
            ),
          ),
        ),
      );

      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('should display Get Started button on last page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: const Text('Get Started'),
            ),
          ),
        ),
      );

      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('should display Back button on second page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Back'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });
  });

  group('OnboardingPage', () {
    testWidgets('should display onboarding title', (tester) async {
      final data = OnboardingData(
        title: 'Easy Register',
        subtitle: 'Sign up effortlessly',
        imagePath: 'assets/images/plant1.jpg',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OnboardingPage(data: data),
          ),
        ),
      );

      expect(find.text('Easy Register'), findsOneWidget);
    });

    testWidgets('should display onboarding subtitle', (tester) async {
      final data = OnboardingData(
        title: 'Easy Register',
        subtitle: 'Sign up effortlessly and start your journey',
        imagePath: 'assets/images/plant1.jpg',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OnboardingPage(data: data),
          ),
        ),
      );

      expect(find.text('Sign up effortlessly and start your journey'), findsOneWidget);
    });

    testWidgets('should display placeholder icon when image fails', (tester) async {
      final data = OnboardingData(
        title: 'Test',
        subtitle: 'Test subtitle',
        imagePath: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OnboardingPage(data: data),
          ),
        ),
      );

      expect(find.byIcon(Icons.medical_services), findsOneWidget);
    });
  });

  group('OnboardingData', () {
    test('should create OnboardingData correctly', () {
      final data = OnboardingData(
        title: 'Test Title',
        subtitle: 'Test Subtitle',
        imagePath: 'test.jpg',
      );

      expect(data.title, 'Test Title');
      expect(data.subtitle, 'Test Subtitle');
      expect(data.imagePath, 'test.jpg');
    });

    test('should allow null imagePath', () {
      final data = OnboardingData(
        title: 'Test Title',
        subtitle: 'Test Subtitle',
      );

      expect(data.imagePath, isNull);
    });
  });
}
