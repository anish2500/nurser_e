import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/features/auth/domain/repositories/auth_repository.dart';
import 'package:nurser_e/features/auth/domain/usecases/logout_usecase.dart';

// Mocking the IAuthRepository interface
class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LogoutUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    // Inject the mock repository into the usecase
    usecase = LogoutUsecase(authRepository: mockRepository);
  });

  group('LogoutUsecase', () {
    test('should return true when logout is successful in repository', () async {
      // Arrange
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.logout()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ApiFailure when repository logout fails on server', () async {
      // Arrange
      const failure = ApiFailure(message: 'Logout failed');
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.logout()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return LocalDatabaseFailure when clearing Hive/local data fails', () async {
      // Arrange
      const failure = LocalDatabaseFailure(message: 'Failed to clear local data');
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.logout()).called(1);
    });

    test('should return NetworkFailure when there is no internet during logout', () async {
      // Arrange
      const failure = NetworkFailure(); // Uses your default "No internet connection" message
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.logout()).called(1);
    });
  });
}