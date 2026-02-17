import 'package:dartz/dartz.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/core/services/storage/user_session_service.dart';
import 'package:nurser_e/core/widgets/my_button.dart';
import 'package:nurser_e/features/auth/domain/usecases/get_current_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/login_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/logout_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/register_usecase.dart';
import 'package:nurser_e/features/auth/presentation/pages/login_screens.dart';
import 'package:nurser_e/features/auth/presentation/pages/signup_screens.dart';
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
      child: const MaterialApp(home: SignupScreens()),
    );
  }

  group('SignupScreen - UI elements', () {
    testWidgets('Should display header text and form fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Register'), findsOneWidget);
      expect(find.text('Create your account to get started'), findsOneWidget);

      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);

      expect(find.text('SignUp'), findsWidgets);

      final richTexts = tester.widgetList<RichText>(find.byType(RichText));

      bool found = false;

      for (final richText in richTexts) {
        final text = richText.text.toPlainText();
        if (text.contains('Already have an account?')) {
          found = true;
          expect(text, contains('Login'));
          break;
        }
      }

      expect(found, true, reason: 'Already have an account? text not found');
    });

    testWidgets('Should display a SignUp Button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('SignUp'), findsWidgets);
    });
  });

  group('SignUpScreens - Form Input', () {
    testWidgets('should allow entering email and passwords', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);

      await tester.enterText(fields.at(0), 'test@example.com');
      await tester.enterText(fields.at(1), 'password123');
      await tester.enterText(fields.at(2), 'password123');
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('password123'), findsNWidgets(2));
    });
  });

  group('SigupScreens - Form validation', () {
    testWidgets('shows error snackbar when fields are empty', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final buttonFinder = find.byType(MyButton);

      await tester.ensureVisible(buttonFinder);

      await tester.tap(buttonFinder);

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('Show error snack bar when passwords do not match', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextField, 'Email Address'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'password123',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Confirm Password'),
        'password321',
      );

      final button = find.byType(MyButton);
      await tester.ensureVisible(button);
      await tester.tap(button);

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match!'), findsOneWidget);

      verifyNever(() => mockRegisterUsecase(any()));
    });
  });

  group('SignUpScreens - Form Input', () {
    testWidgets('Allows entering email and passwords', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final emailField = find.widgetWithText(TextField, 'Email Address');
      final passwordField = find.widgetWithText(TextField, 'Password');
      final confirmField = find.widgetWithText(TextField, 'Confirm Password');

      await tester.enterText(emailField, 'john@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmField, 'password123');

      expect(find.text('john@example.com'), findsOneWidget);
      expect(find.text('password123'), findsNWidgets(2));
    });
  });

  group('SignUpScreens - Form Submission', () {
    testWidgets('calls register usecase when form is valid', (tester) async {
      when(
        () => mockRegisterUsecase(any()),
      ).thenAnswer((_) async => const Right(true));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'john@example.com');
      await tester.enterText(textFields.at(1), 'password123');
      await tester.enterText(textFields.at(2), 'password123');
      await tester.pump();

      final buttonFinder = find.byType(MyButton);
      await tester.ensureVisible(buttonFinder);
      await tester.pumpAndSettle();

      await tester.tap(buttonFinder);


      await tester.pump();

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();


      verify(() => mockRegisterUsecase(any())).called(1);
    });
  });

  group('SignupScreens - Navigation', () {
    testWidgets('navigates to LoginScreens when tapping Login link', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();


      final richTextFinder = find.byElementPredicate((element) {
        if (element.widget is RichText) {
          final richText = element.widget as RichText;
          return richText.text.toPlainText().contains(
            'Already have an account?',
          );
        }
        return false;
      });

      expect(richTextFinder, findsOneWidget);


      await tester.ensureVisible(richTextFinder);
      await tester.pumpAndSettle();

 
      final RichText richTextWidget = tester.widget(richTextFinder);
      final TextSpan textSpan = richTextWidget.text as TextSpan;

      bool foundAndTapped = false;


      textSpan.visitChildren((span) {
        if (span is TextSpan && span.text == 'Login') {
          final recognizer = span.recognizer as TapGestureRecognizer?;
          if (recognizer != null && recognizer.onTap != null) {
            recognizer.onTap!(); 
            foundAndTapped = true;
            return false; 
          }
        }
        return true;
      });

      expect(
        foundAndTapped,
        isTrue,
        reason: 'Login link with TapGestureRecognizer not found',
      );
      await tester.pumpAndSettle();

      expect(find.byType(SignupScreens), findsNothing);
      expect(find.byType(LoginScreens), findsOneWidget);
    });
  });
}
