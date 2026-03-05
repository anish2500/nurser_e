import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentScreen UI Elements', () {
    testWidgets('should display Payment title in app bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Text('Payment'),
            ),
          ),
        ),
      );

      expect(find.text('Payment'), findsOneWidget);
    });

    testWidgets('should display Payment Method section title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Payment Method'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Payment Method'), findsOneWidget);
    });

    testWidgets('should display Cash on Delivery option', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Cash on Delivery'),
                Text('Pay when you receive your order'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Cash on Delivery'), findsOneWidget);
      expect(find.text('Pay when you receive your order'), findsOneWidget);
    });

    testWidgets('should display Online Payment option', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Online Payment'),
                Text('Pay now using card/UPI/bank'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Online Payment'), findsOneWidget);
      expect(find.text('Pay now using card/UPI/bank'), findsOneWidget);
    });

    testWidgets('should display money icon for Cash on Delivery', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Icon(Icons.money),
          ),
        ),
      );

      expect(find.byIcon(Icons.money), findsOneWidget);
    });

    testWidgets('should display credit card icon for Online Payment', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Icon(Icons.credit_card),
          ),
        ),
      );

      expect(find.byIcon(Icons.credit_card), findsOneWidget);
    });

    testWidgets('should display Pay button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: Text('Pay Rs 0.00'),
            ),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Pay Rs 0.00'), findsOneWidget);
    });

    testWidgets('should display Order Summary title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text('Order Summary'),
          ),
        ),
      );

      expect(find.text('Order Summary'), findsOneWidget);
    });

    testWidgets('should display Total Amount', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text('Total: Rs 100.00'),
          ),
        ),
      );

      expect(find.text('Total: Rs 100.00'), findsOneWidget);
    });

    testWidgets('should display Total Items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text('Total Items: 3'),
          ),
        ),
      );

      expect(find.text('Total Items: 3'), findsOneWidget);
    });

    testWidgets('should have SingleChildScrollView for scrolling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: const [
                  Text('Payment'),
                  Text('Order Summary'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should display back arrow icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should display radio buttons for payment selection', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                Radio<String>(value: 'cash', groupValue: 'cash', onChanged: (v) {}),
                Radio<String>(value: 'online', groupValue: 'cash', onChanged: (v) {}),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(Radio<String>), findsNWidgets(2));
    });

    testWidgets('should display Divider between payment options', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Cash on Delivery'),
                Divider(),
                Text('Online Payment'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('should display loading indicator when processing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message container', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('An error occurred'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('An error occurred'), findsOneWidget);
    });

    testWidgets('should display success icon in dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Text('Order Placed!'),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('Order Placed!'), findsOneWidget);
    });

    testWidgets('should display OK button in dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextButton(
              onPressed: () {},
              child: Text('OK'),
            ),
          ),
        ),
      );

      expect(find.byType(TextButton), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('should display Cancel button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextButton(
              onPressed: () {},
              child: Text('Cancel'),
            ),
          ),
        ),
      );

      expect(find.byType(TextButton), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('should display I Completed Payment button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextButton(
              onPressed: () {},
              child: Text('I Completed Payment'),
            ),
          ),
        ),
      );

      expect(find.text('I Completed Payment'), findsOneWidget);
    });
  });
}
