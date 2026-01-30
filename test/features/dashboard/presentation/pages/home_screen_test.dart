import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nurser_e/core/widgets/product_card.dart';
import 'package:nurser_e/features/dashboard/presentation/pages/home_screen.dart';
import 'package:nurser_e/core/widgets/my_searchbox.dart';
import 'package:nurser_e/core/widgets/my_button.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('Renders key static texts and search box', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Check for main title
      expect(find.text('Dashboard'), findsOneWidget);

      // Check for New Arrivals card text
      expect(find.text('New Arrivals'), findsOneWidget);
      expect(find.text('Explore the latest'), findsOneWidget);
      expect(find.text('plant arrived in our garden'), findsOneWidget);

      // Check for sections titles
      expect(find.text('Top Sold'), findsOneWidget);
      expect(find.text('Recent Arrivals'), findsOneWidget);

      // Verify search box is present
      expect(find.byType(my_searchbox), findsOneWidget);

      // Verify Shop Now button exists
      expect(find.byType(MyButton), findsOneWidget);
      expect(find.text('Shop Now'), findsOneWidget);
    });
    testWidgets('Horizontal lists render ProductCard widgets', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(
        1080,
        1920,
      ); // Standard phone resolution
      tester.view.devicePixelRatio = 1.0;

      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Find the Top Sold horizontal ListView
      final topSoldListView = find.byType(ListView).first;

      // Scroll to the end to ensure all ProductCards are visible
      await tester.drag(
        topSoldListView,
        const Offset(-500.0, 0),
      ); // scroll left
      await tester.pumpAndSettle();

      // Now find all ProductCard widgets inside this ListView
      final topSoldCards = find.descendant(
        of: topSoldListView,
        matching: find.byType(ProductCard),
      );
      expect(topSoldCards, findsNWidgets(4));

      // Find the Recent Arrivals horizontal ListView
      final recentArrivalsListView = find.byType(ListView).last;

      // Scroll to the end
      await tester.drag(recentArrivalsListView, const Offset(-500.0, 0));
      await tester.pumpAndSettle();

      // Find ProductCards inside Recent Arrivals
      final recentArrivalCards = find.descendant(
        of: recentArrivalsListView,
        matching: find.byType(ProductCard),
      );
      expect(recentArrivalCards, findsNWidgets(4));
    });

    testWidgets('ProductCard tap works without error', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Tap the first ProductCard in Top Sold
      final topSoldList = find.byType(ProductCard).first;
      await tester.tap(topSoldList);
      await tester.pump();

      // Tap the first ProductCard in Recent Arrivals
      final recentArrivalList = find.byType(ProductCard).last;
      await tester.tap(recentArrivalList);
      await tester.pump();

      // Since onTap is empty, we just ensure no exceptions are thrown
      expect(true, isTrue);
    });

    testWidgets('Scroll works for SingleChildScrollView', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      final scrollable = find.byType(SingleChildScrollView);
      expect(scrollable, findsOneWidget);

      // Scroll down
      await tester.drag(scrollable, const Offset(0, -300));
      await tester.pumpAndSettle();

      // Scroll back up
      await tester.drag(scrollable, const Offset(0, 300));
      await tester.pumpAndSettle();

      // Just ensure scrollable works without errors
      expect(true, isTrue);
    });

    testWidgets('Shop Now button tap works without error', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      final shopNowButton = find.text('Shop Now');
      expect(shopNowButton, findsOneWidget);

      await tester.tap(shopNowButton);
      await tester.pump();

      // onPressed is empty in HomeScreen, just ensure no errors
      expect(true, isTrue);
    });
  });
}
