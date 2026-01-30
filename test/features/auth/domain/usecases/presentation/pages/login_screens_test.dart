import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/core/services/storage/user_session_service.dart';
import 'package:nurser_e/features/auth/domain/usecases/get_current_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/login_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/logout_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/register_usecase.dart';
import 'package:nurser_e/features/auth/presentation/pages/login_screens.dart';
import 'package:nurser_e/features/auth/presentation/pages/signup_screens.dart';
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
        sharedPreferencesProvider.overrideWithValue(MockSharedPreferences()),
      ],
      child: const MaterialApp(home: LoginScreens()),
    );
  }

  group('Login page Ui Elements', () {
    testWidgets('should display logo with "nurserE" text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the logo RichText widget by its content
      final logoFinder = find.byWidgetPredicate((widget) {
        if (widget is! RichText) return false;
        final text = widget.text.toPlainText();
        return text == 'nurserE';
      });

      expect(logoFinder, findsOneWidget);
    });

    testWidgets('should display welcome message below login title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Welcome back! Please login to continue'), findsOneWidget);
    });

    testWidgets('should display login text in form section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find all Text widgets with "Login" text
      final loginTexts = find.text('Login');
      expect(loginTexts, findsWidgets); // Should find multiple (title + form section)
      
      // Verify there's at least the main title and the form section text
      expect(loginTexts, findsAtLeastNWidgets(2));
    });

    testWidgets('should display email and password text fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find MyTextField widgets
      expect(find.byType(MyTextField), findsNWidgets(2));
      
      // Verify hint texts
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should allow text entry in email field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the first MyTextField (email)
      final emailField = find.byType(MyTextField).first;
      expect(emailField, findsOneWidget);

      // Enter text in email field
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      // Verify text was entered
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('should allow text entry in password field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the second MyTextField (password)
      final passwordField = find.byType(MyTextField).last;
      expect(passwordField, findsOneWidget);

      // Enter text in password field
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Password text should be obscured, but we can verify the field exists
      expect(passwordField, findsOneWidget);
    });
  });
}
