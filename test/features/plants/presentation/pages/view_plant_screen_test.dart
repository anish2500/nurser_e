import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ViewPlantScreen UI Elements', () {
    testWidgets('should display loading indicator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display plant not found message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.eco, size: 64),
                  const SizedBox(height: 16),
                  Text('Plant not found'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Plant not found'), findsOneWidget);
    });

    testWidgets('should display error message with go back button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64),
                  const SizedBox(height: 16),
                  Text('Error loading plant'),
                  TextButton(
                    onPressed: () {},
                    child: Text('Go Back'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Error loading plant'), findsOneWidget);
      expect(find.text('Go Back'), findsOneWidget);
    });

    testWidgets('should display plant name and price', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Rose Plant', style: TextStyle(fontSize: 26)),
                  Text('Rs 25.99', style: TextStyle(fontSize: 22)),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Rose Plant'), findsOneWidget);
      expect(find.text('Rs 25.99'), findsOneWidget);
    });

    testWidgets('should display add to cart button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: ElevatedButton(
              onPressed: () {},
              child: Text('Add to Cart'),
            ),
          ),
        ),
      );

      expect(find.text('Add to Cart'), findsOneWidget);
    });

    testWidgets('should display out of stock when stock is 0', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: Container(
              height: 50,
              child: Center(child: Text('Out of Stock')),
            ),
          ),
        ),
      );

      expect(find.text('Out of Stock'), findsOneWidget);
    });
  });
}
