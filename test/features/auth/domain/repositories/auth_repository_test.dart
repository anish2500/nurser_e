import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/features/auth/domain/entities/auth_entity.dart';
import 'package:nurser_e/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  const tAuthEntity = AuthEntity(
    authId: '1',
    email: 'test@example.com',
    username: 'testuser',
    password: 'password123',
  );

  const tEmail = 'test@example.com';
  const tPassword = 'password123';

  group('IAuthRepository Interface Tests', () {
    test('login should return AuthEntity on success', () async {
      when(() => mockRepository.login(tEmail, tPassword))
          .thenAnswer((_) async => const Right(tAuthEntity));

      final result = await mockRepository.login(tEmail, tPassword);

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (entity) => expect(entity.email, tEmail),
      );
    });

    test('login should return Failure on invalid credentials', () async {
      when(() => mockRepository.login(tEmail, tPassword))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Invalid credentials')));

      final result = await mockRepository.login(tEmail, tPassword);

      expect(result.isLeft(), true);
    });

    test('register should return true on success', () async {
      when(() => mockRepository.register(tAuthEntity))
          .thenAnswer((_) async => const Right(true));

      final result = await mockRepository.register(tAuthEntity);

      expect(result, const Right(true));
    });

    test('getCurrentUser should return AuthEntity when user is logged in', () async {
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Right(tAuthEntity));

      final result = await mockRepository.getCurrentUser();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (entity) => expect(entity.username, 'testuser'),
      );
    });

    test('logout should return true on success', () async {
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Right(true));

      final result = await mockRepository.logout();

      expect(result, const Right(true));
    });

    test('isEmailExists should return true when email exists', () async {
      when(() => mockRepository.isEmailExists(tEmail))
          .thenAnswer((_) async => true);

      final result = await mockRepository.isEmailExists(tEmail);

      expect(result, true);
    });

    test('getUserById should return AuthEntity when user exists', () async {
      when(() => mockRepository.getUserById('1'))
          .thenAnswer((_) async => const Right(tAuthEntity));

      final result = await mockRepository.getUserById('1');

      expect(result.isRight(), true);
    });

    test('getUserByEmail should return AuthEntity when user exists', () async {
      when(() => mockRepository.getUserByEmail(tEmail))
          .thenAnswer((_) async => const Right(tAuthEntity));

      final result = await mockRepository.getUserByEmail(tEmail);

      expect(result.isRight(), true);
    });
  });
}
