import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/features/auth/domain/usecases/get_current_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/login_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/logout_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/register_usecase.dart';
import 'package:nurser_e/features/auth/presentation/pages/login_screens.dart';
import 'package:nurser_e/core/services/storage/user_session_service.dart';
import 'package:nurser_e/core/widgets/my_button.dart';
import 'package:nurser_e/core/widgets/my_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockSharedPreferences mockSharedPreferences;

  setUpAll(() {
    registerFallbackValue(
      const RegisterUsecaseParams(
        email: 'fallback@email.com',
        username: 'fallback',
        password: 'fallback',
      ),
    );
    registerFallbackValue(
      const LoginUsecaseParams(
        email: 'fallback@email.com',
        password: 'fallback',
      ),
    );
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockSharedPreferences = MockSharedPreferences();

    when(() => mockSharedPreferences.getString(any())).thenReturn(null);
    when(() => mockSharedPreferences.setString(any(), any()))
        .thenAnswer((_) async => true);
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        getCurrentUserUsecaseProvider.overrideWithValue(
          mockGetCurrentUserUsecase,
        ),
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
        sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
      ],
      child: const MaterialApp(home: LoginScreens()),
    );
  }

  group('Login page UI Elements', () {
    testWidgets('should display logo with nurserE text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final logoFinder = find.byWidgetPredicate((widget) {
        if (widget is! RichText) return false;
        final text = widget.text.toPlainText();
        return text == 'nurserE';
      });

      expect(logoFinder, findsOneWidget);
    });

    testWidgets('should display welcome message below login title',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Welcome back! Please login to continue'),
          findsOneWidget);
    });

    testWidgets('should display login text in form section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final loginTexts = find.text('Login');
      expect(loginTexts, findsAtLeastNWidgets(2));
    });

    testWidgets('should display email and password text fields',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(MyTextField), findsNWidgets(2));
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should allow text entry in email field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final emailField = find.byType(MyTextField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('should allow text entry in password field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final passwordField = find.byType(MyTextField).last;
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      expect(passwordField, findsOneWidget);
    });

    testWidgets('should display Login button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(MyButton), findsOneWidget);
    });

    testWidgets('should display Signup link text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final signupFinder = find.byWidgetPredicate((widget) {
        if (widget is! RichText) return false;
        final text = widget.text.toPlainText();
        return text.contains('SignUp') || text.contains("Don't have an account");
      });
      expect(signupFinder, findsOneWidget);
    });

    testWidgets('should display back button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
    });
  });

  group('Login functionality', () {
    testWidgets('should show error when fields are empty', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final loginButton = find.byType(MyButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('should display error message on login failure',
        (tester) async {
      when(() => mockLoginUsecase(any())).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Invalid credentials')),
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final emailField = find.byType(MyTextField).first;
      final passwordField = find.byType(MyTextField).last;

      await tester.enterText(emailField, 'wrong@example.com');
      await tester.enterText(passwordField, 'wrongpassword');
      await tester.pump();

      final loginButton = find.byType(MyButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('should verify password field exists', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final passwordFields = find.byType(MyTextField);
      expect(passwordFields.last, findsOneWidget);
    });

    testWidgets('should verify email field exists', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final emailFields = find.byType(MyTextField);
      expect(emailFields.first, findsOneWidget);
    });

    testWidgets('should display "Login" text on button when not loading',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final buttonText = find.descendant(
        of: find.byType(MyButton),
        matching: find.text('Login'),
      );
      expect(buttonText, findsOneWidget);
    });
  });
}
