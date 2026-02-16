import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/services/storage/user_session_service.dart';
import 'package:nurser_e/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:nurser_e/features/auth/domain/usecases/get_current_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/login_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/register_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/logout_usecase.dart'; // Add this
import 'package:nurser_e/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/upload_photo_usecase.dart';
import 'package:nurser_e/features/auth/presentation/state/auth_state.dart';

// Provider definition
final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final LogoutUsecase _logoutUsecase;
  late final GetCurrentUserUsecase _getCurrentUserUsecase;
  late final UploadPhotoUsecase _uploadPhotoUsecase;
  late final UpdateProfileUsecase _updateProfileUsecase;

  @override
  AuthState build() {
    // Initialize all usecases
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);
    _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    _uploadPhotoUsecase = ref.read(uploadPhotoUsecaseProvider);
    _updateProfileUsecase = ref.read(updateProfileUsecaseProvider);
    

    return AuthState.initial();
  }

  /// Register User
  Future<void> register({
    required String email,
    required String username,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final params = RegisterUsecaseParams(
      email: email,
      username: username,
      password: password,
    );

    final result = await _registerUsecase(params);

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (isRegistered) => state = state.copyWith(status: AuthStatus.registered),
    );
  }

  /// Login User
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading);

    final params = LoginUsecaseParams(email: email, password: password);

    final result = await _loginUsecase(params);

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (authEntity) => state = state.copyWith(
        status: AuthStatus.authenticated,
        authEntity: authEntity,
      ),
    );
  }

  /// Logout User
  /// This handles clearing the Hive boxes and SharedPreferences via the Usecase
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _logoutUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (success) =>
          state = AuthState.initial(), // Reset to unauthenticated/initial state
    );
  }

  /// Get Current User (Used for Session Persistence)
  Future<void> getCurrentUser() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _getCurrentUserUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        authEntity: user,
      ),
    );
  }

  //upload photo

  Future<void> uploadPhoto(File photo) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _uploadPhotoUsecase(photo);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (imageName) async {
        final userId = ref.read(userSessionServiceProvider).getUserId() ?? '';

        // 🔥 Update profile picture in local datasource
        await ref
            .read(authLocalDatasourceProvider)
            .updateProfilePicture(userId, imageName);
        ref
            .read(userSessionServiceProvider)
            .saveUserSession(
              userId: ref.read(userSessionServiceProvider).getUserId() ?? '',
              email: ref.read(userSessionServiceProvider).getUserEmail() ?? '',
              username:
                  ref.read(userSessionServiceProvider).getUsername() ?? '',
              profileImage: imageName,
            );
        state = state.copyWith(
          status: AuthStatus.loaded,
          uploadPhotoName: imageName,
        );
      },
    );
  }

  /// Update Profile
  Future<void> updateProfile({
    String? fullName,
    String? username,
    String? email,
    File? profilePicture,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final params = UpdateProfileParams(
      fullName: fullName,
      username: username,
      email: email,
      profilePicture: profilePicture,
    );

    final result = await _updateProfileUsecase(params);

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) {
        // Update local storage with new user data
        ref.read(userSessionServiceProvider).saveUserSession(
          userId: user.authId ?? '',
          email: user.email,
          username: user.username,
          profileImage: user.profilePicture ?? '',
        );
        
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: user,
        );
      },
    );
  }

  /// Reset State
  void resetState() {
    state = AuthState.initial();
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

