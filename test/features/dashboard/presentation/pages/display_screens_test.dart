import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/features/dashboard/presentation/pages/display_screens.dart';

void main() {
  group('DisplayScreens UI Tests', () {
    testWidgets('Displays texts and buttons correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DisplayScreens()),
        ),
      );

      // Verify main texts
      expect(find.text('Hello,'), findsOneWidget);
      expect(find.text('Welcome to nurserE'), findsOneWidget);
      expect(find.text('Your Green Companion'), findsOneWidget);

      // Verify buttons
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('SignUp'), findsOneWidget);
    });

  });
}
