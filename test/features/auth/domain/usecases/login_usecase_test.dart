import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/features/auth/domain/entities/auth_entity.dart';
import 'package:nurser_e/features/auth/domain/repositories/auth_repository.dart';
import 'package:nurser_e/features/auth/domain/usecases/login_usecase.dart';

// Mocking the IAuthRepository interface
class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUsecase(authRepository: mockRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tParams = LoginUsecaseParams(email: tEmail, password: tPassword);

  const tUser = AuthEntity(
    authId: '1',
    email: tEmail,
    username: 'testuser',
  );

  group('LoginUsecase', () {
    test('should return AuthEntity when login is successful in repository', () async {
      // Arrange
      when(() => mockRepository.login(tEmail, tPassword))
          .thenAnswer((_) async => const Right(tUser));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(tUser));
      verify(() => mockRepository.login(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository login fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Invalid credentials');
      when(() => mockRepository.login(tEmail, tPassword))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.login(tEmail, tPassword)).called(1);
    });

    test('should return NetworkFailure from repository on connectivity issues', () async {
      // Arrange
      const failure = NetworkFailure();
      when(() => mockRepository.login(tEmail, tPassword))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.login(tEmail, tPassword)).called(1);
    });

    test('should verify correct data is passed through to the repository', () async {
      // Arrange
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => const Right(tUser));

      // Act
      await usecase(tParams);

      // Assert
      verify(() => mockRepository.login(tEmail, tPassword)).called(1);
    });
  });

  group('LoginUsecaseParams', () {
    test('should support value equality via Equatable', () {
      // Arrange
      const params1 = LoginUsecaseParams(email: tEmail, password: tPassword);
      const params2 = LoginUsecaseParams(email: tEmail, password: tPassword);
      const params3 = LoginUsecaseParams(email: 'different', password: tPassword);

      // Assert
      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
      expect(params1.props, [tEmail, tPassword]);
    });
  });
}