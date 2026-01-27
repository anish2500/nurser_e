import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/features/auth/domain/entities/auth_entity.dart';
import 'package:nurser_e/features/auth/domain/repositories/auth_repository.dart';
import 'package:nurser_e/features/auth/domain/usecases/get_current_usecase.dart';


// Mocking the Interface (IAuthRepository)
class MockAuthRepository extends Mock implements IAuthRepository{
  
}

void main() {
  late GetCurrentUserUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    // Inject the mock repository into the usecase
    usecase = GetCurrentUserUsecase(authRepository: mockRepository);
  });

  const tUser = AuthEntity(
    authId: '1',
    email: 'test@example.com',
    username: 'testuser',
  );

  group('GetCurrentUserUsecase', () {
    test('should return AuthEntity when repository successfully fetches user', () async {
      // Arrange
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Right(tUser));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Right(tUser));
      verify(() => mockRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository returns an ApiFailure', () async {
      // Arrange
      const failure = ApiFailure(message: 'User not authenticated');
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.getCurrentUser()).called(1);
    });

    test('should return LocalDatabaseFailure when database read fails', () async {
      // Arrange
      const failure = LocalDatabaseFailure(message: 'Failed to read user data');
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.getCurrentUser()).called(1);
    });

    test('should return user with all optional fields populated', () async {
      // Arrange
      const userWithAllFields = AuthEntity(
        authId: '1',
        email: 'test@example.com',
        username: 'testuser',
      );
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Right(userWithAllFields));

      // Act
      final result = await usecase();

      // Assert
      result.fold(
        (failure) => fail('Test failed: expected Right but got Left'),
        (user) {
          expect(user, equals(userWithAllFields));
        },
      );
    });
  });
}