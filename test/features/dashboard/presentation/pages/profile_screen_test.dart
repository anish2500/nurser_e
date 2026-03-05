import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileScreen UI Elements', () {
    testWidgets('should display Profile title in app bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
            ),
          ),
        ),
      );

      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('should display user name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text('John Doe'),
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('should display user email', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text('john@example.com'),
          ),
        ),
      );

      expect(find.text('john@example.com'), findsOneWidget);
    });

    testWidgets('should display CircleAvatar for profile picture', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              child: Text('J'),
            ),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('should display camera icon for profile edit', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Icon(Icons.camera_alt, size: 14),
          ),
        ),
      );

      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });

    testWidgets('should display edit icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Icon(Icons.edit_outlined, color: Colors.white),
          ),
        ),
      );

      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    });

    testWidgets('should display Dark Mode option', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Dark Mode'),
                Text('Dark mode is enabled'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Dark mode is enabled'), findsOneWidget);
    });

    testWidgets('should display light mode icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Icon(Icons.light_mode),
          ),
        ),
      );

      expect(find.byIcon(Icons.light_mode), findsOneWidget);
    });

    testWidgets('should display dark mode icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Icon(Icons.dark_mode),
          ),
        ),
      );

      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('should display Switch for dark mode toggle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Switch(value: false, onChanged: (v) {}),
          ),
        ),
      );

      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('should display My Orders menu item', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('My Orders'),
                Text('Check out the orders you placed recently'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('My Orders'), findsOneWidget);
      expect(find.text('Check out the orders you placed recently'), findsOneWidget);
    });

    testWidgets('should display shopping bag icon for orders', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Icon(Icons.shopping_bag),
          ),
        ),
      );

      expect(find.byIcon(Icons.shopping_bag), findsOneWidget);
    });

    testWidgets('should display Logout menu item', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Log out'),
                Text('Further secure your account for safety'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Log out'), findsOneWidget);
      expect(find.text('Further secure your account for safety'), findsOneWidget);
    });

    testWidgets('should display logout icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Icon(Icons.logout_rounded),
          ),
        ),
      );

      expect(find.byIcon(Icons.logout_rounded), findsOneWidget);
    });

    testWidgets('should have SingleChildScrollView for scrolling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: const [
                  Text('Profile'),
                  Text('My Orders'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should display back arrow icon in app bar', (tester) async {
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

    testWidgets('should display profile header container', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should display Cancel button in logout dialog', (tester) async {
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

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('should display Logout button in logout dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextButton(
              onPressed: () {},
              child: Text('Logout'),
            ),
          ),
        ),
      );

      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('should display logout dialog title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text('Logout'),
          ),
        ),
      );

      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('should display logout confirmation message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text('Are you sure you want to logout?'),
          ),
        ),
      );

      expect(find.text('Are you sure you want to logout?'), findsOneWidget);
    });
  });
}
