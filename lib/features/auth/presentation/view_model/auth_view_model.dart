import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/features/auth/domain/usecases/login_usecase.dart';
import 'package:nurser_e/features/auth/domain/usecases/register_usecase.dart';
import 'package:nurser_e/features/auth/presentation/state/auth_state.dart';

// Provider definition
final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;

  @override
  AuthState build() {
    // Initialize usecases from their respective providers
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    
    // Returns the initial state (Make sure AuthStatus is .initial here)
    return AuthState.initial(); 
  }

  /// Register User
  Future<void> register({
    required String email,
    required String username,
    required String password,
  }) async {
    // 1. Set state to loading
    state = state.copyWith(status: AuthStatus.loading);

    final params = RegisterUsecaseParams(
      email: email,
      username: username,
      password: password,
    );

    // 2. Execute usecase
    final result = await _registerUsecase(params);

    // 3. Handle result
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (isRegistered) {
        state = state.copyWith(status: AuthStatus.registered);
      },
    );
  }

  /// Login User
  Future<void> login({required String email, required String password}) async {
    // 1. Set state to loading
    state = state.copyWith(status: AuthStatus.loading);

    final params = LoginUsecaseParams(email: email, password: password);

    // 2. Execute usecase
    final result = await _loginUsecase(params);

    // 3. Handle result
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (authEntity) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: authEntity,
        );
      },
    );
  }

  /// Reset State
  /// Call this when navigating between Login and Signup to clear errors/loading states
  void resetState() {
    state = AuthState.initial();
  }
}