import 'package:flutter_test/flutter_test.dart';
import 'package:nurser_e/features/auth/domain/entities/auth_entity.dart';

void main() {
  group('AuthEntity', () {
    const tAuthId = '123';
    const tEmail = 'test@example.com';
    const tUsername = 'testuser';
    const tPassword = 'password123';
    const tProfilePicture = 'https://example.com/avatar.png';

    test('should create AuthEntity with all required fields', () {
      const entity = AuthEntity(
        email: tEmail,
        username: tUsername,
      );

      expect(entity.email, tEmail);
      expect(entity.username, tUsername);
      expect(entity.authId, isNull);
      expect(entity.password, isNull);
      expect(entity.profilePicture, isNull);
    });

    test('should create AuthEntity with all fields', () {
      const entity = AuthEntity(
        authId: tAuthId,
        email: tEmail,
        username: tUsername,
        password: tPassword,
        profilePicture: tProfilePicture,
      );

      expect(entity.authId, tAuthId);
      expect(entity.email, tEmail);
      expect(entity.username, tUsername);
      expect(entity.password, tPassword);
      expect(entity.profilePicture, tProfilePicture);
    });

    test('should support value equality via Equatable', () {
      const entity1 = AuthEntity(
        authId: tAuthId,
        email: tEmail,
        username: tUsername,
        password: tPassword,
        profilePicture: tProfilePicture,
      );

      const entity2 = AuthEntity(
        authId: tAuthId,
        email: tEmail,
        username: tUsername,
        password: tPassword,
        profilePicture: tProfilePicture,
      );

      expect(entity1, equals(entity2));
    });

    test('should not be equal when fields differ', () {
      const entity1 = AuthEntity(
        email: tEmail,
        username: tUsername,
      );

      const entity2 = AuthEntity(
        email: 'different@example.com',
        username: tUsername,
      );

      expect(entity1, isNot(equals(entity2)));
    });

    test('should not be equal when authId differs', () {
      const entity1 = AuthEntity(
        authId: '1',
        email: tEmail,
        username: tUsername,
      );

      const entity2 = AuthEntity(
        authId: '2',
        email: tEmail,
        username: tUsername,
      );

      expect(entity1, isNot(equals(entity2)));
    });

    test('props should include all fields', () {
      const entity = AuthEntity(
        authId: tAuthId,
        email: tEmail,
        username: tUsername,
        password: tPassword,
        profilePicture: tProfilePicture,
      );

      expect(entity.props, [
        tAuthId,
        tEmail,
        tUsername,
        tPassword,
        tProfilePicture,
      ]);
    });

    test('props should handle null values', () {
      const entity = AuthEntity(
        email: tEmail,
        username: tUsername,
      );

      expect(entity.props, [
        null,
        tEmail,
        tUsername,
        null,
        null,
      ]);
    });
  });
}
