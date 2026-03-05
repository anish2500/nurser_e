import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nurser_e/core/services/hive/hive_service.dart';
import 'package:nurser_e/core/services/storage/user_session_service.dart';
import 'package:nurser_e/core/widgets/my_button.dart';
import 'package:nurser_e/features/auth/presentation/pages/login_screens.dart';
import 'package:nurser_e/features/auth/presentation/pages/signup_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Integration Tests', () {
    late SharedPreferences sharedPreferences;
    late HiveService hiveService;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
      
      hiveService = HiveService();
      await hiveService.init();
    });

    group('Login Page Integration Tests', () {
      Widget createLoginPage() {
        return ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            hiveServiceProvider.overrideWithValue(hiveService),
          ],
          child: const MaterialApp(home: LoginScreens()),
        );
      }

      testWidgets('Login page should display welcome text', (tester) async {
        await tester.pumpWidget(createLoginPage());
        await tester.pumpAndSettle();

        expect(find.text('Welcome back! Please login to continue'), findsOneWidget);
      });

      testWidgets('Login page should display text fields', (tester) async {
        await tester.pumpWidget(createLoginPage());
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsNWidgets(2));
      });

      testWidgets('Login page should allow text entry in email field', (tester) async {
        await tester.pumpWidget(createLoginPage());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextField).first,
          'test@example.com',
        );
        await tester.pump();
        expect(find.text('test@example.com'), findsOneWidget);
      });

      testWidgets('Login page should allow text entry in password field', (tester) async {
        await tester.pumpWidget(createLoginPage());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).last, 'password123');
        await tester.pump();
        expect(find.text('password123'), findsOneWidget);
      });

      testWidgets('Login page should show validation error for empty fields', (tester) async {
        await tester.pumpWidget(createLoginPage());
        await tester.pumpAndSettle();

        final loginButton = find.widgetWithText(MyButton, 'Login');
        await tester.tap(loginButton);
        await tester.pump();

        expect(find.text('Please fill in all fields'), findsOneWidget);
      });

      testWidgets('Login page should have back button', (tester) async {
        await tester.pumpWidget(createLoginPage());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      });

      testWidgets('Login page should have login button', (tester) async {
        await tester.pumpWidget(createLoginPage());
        await tester.pumpAndSettle();

        expect(find.widgetWithText(MyButton, 'Login'), findsOneWidget);
      });
    });

    group('Signup Page Integration Tests', () {
      Widget createSignupPage() {
        return ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            hiveServiceProvider.overrideWithValue(hiveService),
          ],
          child: const MaterialApp(home: SignupScreens()),
        );
      }

      testWidgets('Signup page should display register text', (tester) async {
        await tester.pumpWidget(createSignupPage());
        await tester.pumpAndSettle();

        expect(find.text('Register'), findsOneWidget);
      });

      testWidgets('Signup page should display text fields', (tester) async {
        await tester.pumpWidget(createSignupPage());
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsNWidgets(3));
      });

      testWidgets('Signup page should allow text entry in email field', (tester) async {
        await tester.pumpWidget(createSignupPage());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextField).first,
          'newuser@example.com',
        );
        await tester.pump();
        expect(find.text('newuser@example.com'), findsOneWidget);
      });

      testWidgets('Signup page should show validation error for empty fields', (tester) async {
        await tester.pumpWidget(createSignupPage());
        await tester.pumpAndSettle();

        final signupButton = find.widgetWithText(MyButton, 'SignUp');
        await tester.tap(signupButton);
        await tester.pump();

        expect(find.text('Please fill in all fields'), findsOneWidget);
      });

      testWidgets('Signup page should show password mismatch error', (tester) async {
        await tester.pumpWidget(createSignupPage());
        await tester.pumpAndSettle();

        final textFields = find.byType(TextField);
        await tester.enterText(textFields.at(0), 'test@example.com');
        await tester.enterText(textFields.at(1), 'password123');
        await tester.enterText(textFields.last, 'differentpassword');
        await tester.pump();

        final signupButton = find.widgetWithText(MyButton, 'SignUp');
        await tester.tap(signupButton);
        await tester.pump();

        expect(find.text('Passwords do not match!'), findsOneWidget);
      });

      testWidgets('Signup page should have back button', (tester) async {
        await tester.pumpWidget(createSignupPage());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      });

      testWidgets('Signup page should have signup button', (tester) async {
        await tester.pumpWidget(createSignupPage());
        await tester.pumpAndSettle();

        expect(find.widgetWithText(MyButton, 'SignUp'), findsOneWidget);
      });
    });
  });
}
