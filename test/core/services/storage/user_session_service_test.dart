import 'package:flutter_test/flutter_test.dart';
import 'package:nurser_e/core/services/storage/user_session_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late UserSessionService userSessionService;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    userSessionService = UserSessionService(prefs: mockPrefs);
  });

  const tUserId = 'user_123';
  const tEmail = 'test@example.com';
  const tUsername = 'testuser';
  const tProfilePicture = 'https://example.com/profile.jpg';

  const keyIsLoggedIn = 'is_logged_in';
  const keyUserId = 'user_id';
  const keyUserEmail = 'user_email';
  const keyUsername = 'username';
  const keyUserProfileImage = 'user_profile_image';

  group('UserSessionService', () {
    group('saveUserSession', () {
      test('should save required user session data', () async {
        when(() => mockPrefs.setBool(keyIsLoggedIn, true))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserId, tUserId))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserEmail, tEmail))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUsername, tUsername))
            .thenAnswer((_) async => true);

        await userSessionService.saveUserSession(
          userId: tUserId,
          email: tEmail,
          username: tUsername,
        );

        verify(() => mockPrefs.setBool(keyIsLoggedIn, true)).called(1);
        verify(() => mockPrefs.setString(keyUserId, tUserId)).called(1);
        verify(() => mockPrefs.setString(keyUserEmail, tEmail)).called(1);
        verify(() => mockPrefs.setString(keyUsername, tUsername)).called(1);
      });

      test('should save optional profile image when provided', () async {
        when(() => mockPrefs.setBool(keyIsLoggedIn, true))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserId, tUserId))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserEmail, tEmail))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUsername, tUsername))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserProfileImage, tProfilePicture))
            .thenAnswer((_) async => true);

        await userSessionService.saveUserSession(
          userId: tUserId,
          email: tEmail,
          username: tUsername,
          profileImage: tProfilePicture,
        );

        verify(() => mockPrefs.setString(keyUserProfileImage, tProfilePicture))
            .called(1);
      });
    });

    group('isLoggedIn', () {
      test('should return true when user is logged in', () {
        when(() => mockPrefs.getBool(keyIsLoggedIn)).thenReturn(true);

        final result = userSessionService.isLoggedIn();

        expect(result, true);
      });

      test('should return false when user is not logged in', () {
        when(() => mockPrefs.getBool(keyIsLoggedIn)).thenReturn(false);

        final result = userSessionService.isLoggedIn();

        expect(result, false);
      });

      test('should return false when key does not exist', () {
        when(() => mockPrefs.getBool(keyIsLoggedIn)).thenReturn(null);

        final result = userSessionService.isLoggedIn();

        expect(result, false);
      });
    });

    group('getUserId', () {
      test('should return user ID when it exists', () {
        when(() => mockPrefs.getString(keyUserId)).thenReturn(tUserId);

        final result = userSessionService.getUserId();

        expect(result, tUserId);
      });

      test('should return null when user ID does not exist', () {
        when(() => mockPrefs.getString(keyUserId)).thenReturn(null);

        final result = userSessionService.getUserId();

        expect(result, isNull);
      });
    });

    group('getUserEmail', () {
      test('should return email when it exists', () {
        when(() => mockPrefs.getString(keyUserEmail)).thenReturn(tEmail);

        final result = userSessionService.getUserEmail();

        expect(result, tEmail);
      });

      test('should return null when email does not exist', () {
        when(() => mockPrefs.getString(keyUserEmail)).thenReturn(null);

        final result = userSessionService.getUserEmail();

        expect(result, isNull);
      });
    });

    group('getUsername', () {
      test('should return username when it exists', () {
        when(() => mockPrefs.getString(keyUsername)).thenReturn(tUsername);

        final result = userSessionService.getUsername();

        expect(result, tUsername);
      });

      test('should return null when username does not exist', () {
        when(() => mockPrefs.getString(keyUsername)).thenReturn(null);

        final result = userSessionService.getUsername();

        expect(result, isNull);
      });
    });

    group('getUserProfileImage', () {
      test('should return profile image when it exists', () {
        when(() => mockPrefs.getString(keyUserProfileImage))
            .thenReturn(tProfilePicture);

        final result = userSessionService.getUserProfileImage();

        expect(result, tProfilePicture);
      });

      test('should return null when profile image does not exist', () {
        when(() => mockPrefs.getString(keyUserProfileImage)).thenReturn(null);

        final result = userSessionService.getUserProfileImage();

        expect(result, isNull);
      });
    });

    group('clearUserSession', () {
      test('should remove all user session data', () async {
        when(() => mockPrefs.remove(keyUserEmail))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.remove(keyUsername))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.remove(keyUserId))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.remove(keyIsLoggedIn))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.remove(keyUserProfileImage))
            .thenAnswer((_) async => true);

        await userSessionService.clearUserSession();

        verify(() => mockPrefs.remove(keyUserEmail)).called(1);
        verify(() => mockPrefs.remove(keyUsername)).called(1);
        verify(() => mockPrefs.remove(keyUserId)).called(1);
        verify(() => mockPrefs.remove(keyIsLoggedIn)).called(1);
        verify(() => mockPrefs.remove(keyUserProfileImage)).called(1);
      });
    });
  });
}
