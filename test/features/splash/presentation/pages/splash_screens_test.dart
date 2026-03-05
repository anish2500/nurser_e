import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/core/services/storage/user_session_service.dart';
import 'package:nurser_e/features/splash/presentation/pages/splash_screens.dart';

class MockUserSessionService extends Mock implements UserSessionService {}

void main() {
  late MockUserSessionService mockUserSessionService;

  setUp(() {
    mockUserSessionService = MockUserSessionService();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        userSessionServiceProvider.overrideWithValue(mockUserSessionService),
      ],
      child: const MaterialApp(
        home: SplashScreens(),
      ),
    );
  }

  group('SplashScreens', () {
    testWidgets('should display logo image', (tester) async {
      when(() => mockUserSessionService.isLoggedIn()).thenReturn(false);

      await tester.pumpWidget(createWidgetUnderTest());
      
      // Pump to allow widget to build
      await tester.pump();
      
      // Verify logo is displayed
      expect(find.byType(Image), findsOneWidget);
      
      // Complete the timer to avoid pending timer error
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('should display RichText for title', (tester) async {
      when(() => mockUserSessionService.isLoggedIn()).thenReturn(false);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      
      // Verify RichText is displayed
      expect(find.byType(RichText), findsOneWidget);
      
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('should have Scaffold widget', (tester) async {
      when(() => mockUserSessionService.isLoggedIn()).thenReturn(false);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      
      // Verify Scaffold is displayed
      expect(find.byType(Scaffold), findsOneWidget);
      
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('should display app bar', (tester) async {
      when(() => mockUserSessionService.isLoggedIn()).thenReturn(false);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      
      // Verify AppBar is displayed
      expect(find.byType(AppBar), findsOneWidget);
      
      await tester.pump(const Duration(seconds: 3));
    });
  });
}
