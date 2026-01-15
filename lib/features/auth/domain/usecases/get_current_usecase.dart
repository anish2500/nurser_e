import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/auth/data/repositories/auth_repository.dart';
// Ensure this matches your UsecaseWithoutParams location
import 'package:nurser_e/features/auth/domain/entities/auth_entity.dart';
import 'package:nurser_e/features/auth/domain/repositories/auth_repository.dart';

// 1. Create the Provider for the GetCurrentUser Usecase
final getCurrentUserUsecaseProvider = Provider<GetCurrentUserUsecase>((ref) {
  // Accessing the Repository interface
  final authRepository = ref.read(authRepositoryProvider);
  return GetCurrentUserUsecase(authRepository: authRepository);
});

// 2. Define the Usecase Class
class GetCurrentUserUsecase implements UsecaseWithoutParams<AuthEntity> {
  final IAuthRepository _authRepository;

  GetCurrentUserUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call() async {
    // This calls the repository, which fetches the AuthHiveModel 
    // and converts it into an AuthEntity for the UI to use
    return await _authRepository.getCurrentUser();
  }
}