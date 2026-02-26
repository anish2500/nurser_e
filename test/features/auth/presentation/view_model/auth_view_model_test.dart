import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/services/storage/user_session_service.dart';
import 'package:nurser_e/features/auth/domain/entities/auth_entity.dart';
import 'package:nurser_e/features/auth/domain/usecases/get_current_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/login_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/register_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/logout_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/upload_photo_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:nurser_e/features/auth/presentation/state/auth_state.dart';
import 'package:nurser_e/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockUploadPhotoUsecase extends Mock implements UploadPhotoUsecase {}

class MockUpdateProfileUsecase extends Mock implements UpdateProfileUsecase {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class FileFake extends Fake implements File {}

void main() {
  late ProviderContainer container;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockUploadPhotoUsecase mockUploadPhotoUsecase;
  late MockUpdateProfileUsecase mockUpdateProfileUsecase;
  late MockSharedPreferences mockSharedPreferences;

  setUpAll(() {
    registerFallbackValue(FileFake());
    registerFallbackValue(
      RegisterUsecaseParams(
        email: 'fallback@test.com',
        username: 'fallback',
        password: 'fallback',
      ),
    );
    registerFallbackValue(
      const LoginUsecaseParams(email: 'fallback@test.com', password: 'fallback'),
    );
    registerFallbackValue(
      const UpdateProfileParams(),
    );
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockUploadPhotoUsecase = MockUploadPhotoUsecase();
    mockUpdateProfileUsecase = MockUpdateProfileUsecase();
    mockSharedPreferences = MockSharedPreferences();

    when(() => mockSharedPreferences.getString(any())).thenReturn(null);
    when(() => mockSharedPreferences.setString(any(), any()))
        .thenAnswer((_) async => true);
    when(() => mockSharedPreferences.getBool(any())).thenReturn(null);
    when(() => mockSharedPreferences.setBool(any(), any()))
        .thenAnswer((_) async => true);

    container = ProviderContainer(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
        getCurrentUserUsecaseProvider.overrideWithValue(
          mockGetCurrentUserUsecase,
        ),
        uploadPhotoUsecaseProvider.overrideWithValue(mockUploadPhotoUsecase),
        updateProfileUsecaseProvider.overrideWithValue(mockUpdateProfileUsecase),
        sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  const tUser = AuthEntity(
    authId: '1',
    email: 'test@example.com',
    username: 'testuser',
  );

  group('AuthViewModel', () {
    test('initial state is correct', () {
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.initial);
      expect(state.authEntity, isNull);
      expect(state.errorMessage, isNull);
      expect(state.uploadPhotoName, isNull);
    });

    group('register', () {
      test('success', () async {
        when(() => mockRegisterUsecase(any()))
            .thenAnswer((_) async => const Right(true));

        final viewModel = container.read(authViewModelProvider.notifier);
        await viewModel.register(
          email: 'test@example.com',
          username: 'testuser',
          password: '1234',
        );

        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.registered);
        verify(() => mockRegisterUsecase(any())).called(1);
      });

      test('failure', () async {
        const failure = ApiFailure(message: 'Email exists');
        when(() => mockRegisterUsecase(any()))
            .thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(authViewModelProvider.notifier);
        await viewModel.register(
          email: 'test@example.com',
          username: 'testuser',
          password: '1234',
        );

        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.error);
        expect(state.errorMessage, 'Email exists');
      });
    });

    group('login', () {
      test('success', () async {
        when(() => mockLoginUsecase(any()))
            .thenAnswer((_) async => const Right(tUser));

        final viewModel = container.read(authViewModelProvider.notifier);
        await viewModel.login(email: 'test@example.com', password: '1234');

        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.authenticated);
        expect(state.authEntity, tUser);
      });

      test('failure', () async {
        const failure = ApiFailure(message: 'Invalid credentials');
        when(() => mockLoginUsecase(any()))
            .thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(authViewModelProvider.notifier);
        await viewModel.login(email: 'test@example.com', password: '1234');

        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.error);
        expect(state.errorMessage, 'Invalid credentials');
      });
    });

    group('logout', () {
      test('success', () async {
        when(() => mockLogoutUsecase())
            .thenAnswer((_) async => const Right(true));

        final viewModel = container.read(authViewModelProvider.notifier);
        await viewModel.logout();

        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.initial);
        expect(state.authEntity, isNull);
      });

      test('failure', () async {
        const failure = ApiFailure(message: 'Logout failed');
        when(() => mockLogoutUsecase())
            .thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(authViewModelProvider.notifier);
        await viewModel.logout();

        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.error);
        expect(state.errorMessage, 'Logout failed');
      });
    });

    group('getCurrentUser', () {
      test('success', () async {
        when(() => mockGetCurrentUserUsecase())
            .thenAnswer((_) async => const Right(tUser));

        final viewModel = container.read(authViewModelProvider.notifier);
        await viewModel.getCurrentUser();

        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.authenticated);
        expect(state.authEntity, tUser);
      });

      test('failure', () async {
        const failure = ApiFailure(message: 'User not found');
        when(() => mockGetCurrentUserUsecase())
            .thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(authViewModelProvider.notifier);
        await viewModel.getCurrentUser();

        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.unauthenticated);
        expect(state.errorMessage, 'User not found');
      });
    });

    group('uploadPhoto', () {
      final tFile = File('path/to/file.jpg');

      test('success', () async {
        when(() => mockUploadPhotoUsecase(any()))
            .thenAnswer((_) async => const Right('image.jpg'));

        final viewModel = container.read(authViewModelProvider.notifier);
        await viewModel.uploadPhoto(tFile);
        await Future.delayed(const Duration(milliseconds: 100));

        final state = container.read(authViewModelProvider);
        expect(state.uploadPhotoName, 'image.jpg');
      });

      test('failure', () async {
        const failure = ApiFailure(message: 'Upload failed');
        when(() => mockUploadPhotoUsecase(any()))
            .thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(authViewModelProvider.notifier);
        await viewModel.uploadPhoto(tFile);

        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.error);
        expect(state.errorMessage, 'Upload failed');
      });
    });

    group('resetState', () {
      test('resets state to initial', () {
        final viewModel = container.read(authViewModelProvider.notifier);
        viewModel.resetState();

        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.initial);
        expect(state.authEntity, isNull);
        expect(state.errorMessage, isNull);
      });
    });

    group('clearError', () {
      test('clears error message', () {
        final viewModel = container.read(authViewModelProvider.notifier);
        viewModel.clearError();

        final state = container.read(authViewModelProvider);
        expect(state.errorMessage, isNull);
      });
    });
  });
}
