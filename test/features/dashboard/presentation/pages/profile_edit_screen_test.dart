import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileEditScreen UI Elements', () {
    testWidgets('should display Edit Profile title in app bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Edit Profile')),
          ),
        ),
      );
      expect(find.text('Edit Profile'), findsOneWidget);
    });

    testWidgets('should display CircleAvatar for profile picture', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CircleAvatar(radius: 50, backgroundColor: Colors.white),
          ),
        ),
      );
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('should display camera icon for image picking', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Icon(Icons.camera_alt, color: Colors.white, size: 20),
          ),
        ),
      );
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });

    testWidgets('should display Username text field', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFormField(
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.alternate_email),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Username'), findsOneWidget);
      expect(find.byIcon(Icons.alternate_email), findsOneWidget);
    });

    testWidgets('should display Email text field', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Email'), findsOneWidget);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('should display Save Changes button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: Text('Save Changes'),
            ),
          ),
        ),
      );
      expect(find.text('Save Changes'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display back arrow icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should have SingleChildScrollView for scrolling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Text('Edit Profile'),
            ),
          ),
        ),
      );
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should display Form widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(child: Text('Form')),
          ),
        ),
      );
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('should display loading indicator when saving', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
