import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project specific imports
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/features/auth/domain/entities/auth_entity.dart';
import 'package:nurser_e/features/auth/domain/repositories/auth_repository.dart';
import 'package:nurser_e/features/auth/domain/usecases/register_usecase.dart';

// Mocking the interface
class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository mockRepository;

  setUpAll(() {
    // registerFallbackValue is necessary when using any() with custom types in mocktail
    registerFallbackValue(
      const AuthEntity(
        email: '',
        username: '',
        password: '',
      ),
    );
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: mockRepository);
  });

  const tEmail = 'test@example.com';
  const tUsername = 'testuser';
  const tPassword = 'password123';

  const tParams = RegisterUsecaseParams(
    email: tEmail,
    username: tUsername,
    password: tPassword,
  );

  group('RegisterUsecase', () {
    test('should return true when registration is successful in repository', () async {
      // Arrange
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should map RegisterUsecaseParams to AuthEntity correctly', () async {
      // Arrange
      AuthEntity? capturedEntity;
      when(() => mockRepository.register(any())).thenAnswer((invocation) async {
        capturedEntity = invocation.positionalArguments[0] as AuthEntity;
        return const Right(true);
      });

      // Act
      await usecase(tParams);

      // Assert
      expect(capturedEntity, isNotNull);
      expect(capturedEntity?.email, tEmail);
      expect(capturedEntity?.username, tUsername);
      expect(capturedEntity?.password, tPassword);
    });

    test('should return ApiFailure when repository registration fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Email already exists');
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.register(any())).called(1);
    });

    test('should return NetworkFailure when connectivity is lost', () async {
      // Arrange
      const failure = NetworkFailure();
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.register(any())).called(1);
    });
  });

  group('RegisterUsecaseParams', () {
    test('should support value equality', () {
      // Arrange
      const params1 = RegisterUsecaseParams(
        email: tEmail,
        username: tUsername,
        password: tPassword,
      );
      const params2 = RegisterUsecaseParams(
        email: tEmail,
        username: tUsername,
        password: tPassword,
      );

      // Assert
      expect(params1, equals(params2));
      expect(params1.props, [tEmail, tUsername, tPassword]);
    });
  });
}