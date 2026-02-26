import 'package:flutter_test/flutter_test.dart';
import 'package:nurser_e/core/services/storage/token_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late TokenService tokenService;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    tokenService = TokenService(prefs: mockPrefs);
  });

  const tToken = 'test_auth_token_123';
  const tokenKey = 'auth_token';

  group('TokenService', () {
    group('saveToken', () {
      test('should save token to SharedPreferences', () async {
        when(() => mockPrefs.setString(tokenKey, tToken))
            .thenAnswer((_) async => true);

        await tokenService.saveToken(tToken);

        verify(() => mockPrefs.setString(tokenKey, tToken)).called(1);
      });

      test('should handle empty token', () async {
        when(() => mockPrefs.setString(tokenKey, ''))
            .thenAnswer((_) async => true);

        await tokenService.saveToken('');

        verify(() => mockPrefs.setString(tokenKey, '')).called(1);
      });
    });

    group('getToken', () {
      test('should return token when it exists', () {
        when(() => mockPrefs.getString(tokenKey)).thenReturn(tToken);

        final result = tokenService.getToken();

        expect(result, tToken);
        verify(() => mockPrefs.getString(tokenKey)).called(1);
      });

      test('should return null when token does not exist', () {
        when(() => mockPrefs.getString(tokenKey)).thenReturn(null);

        final result = tokenService.getToken();

        expect(result, isNull);
        verify(() => mockPrefs.getString(tokenKey)).called(1);
      });
    });

    group('removeToken', () {
      test('should remove token from SharedPreferences', () async {
        when(() => mockPrefs.remove(tokenKey)).thenAnswer((_) async => true);

        await tokenService.removeToken();

        verify(() => mockPrefs.remove(tokenKey)).called(1);
      });
    });

    group('token lifecycle', () {
      test('should save, retrieve, and remove token correctly', () {
        when(() => mockPrefs.setString(tokenKey, tToken))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.getString(tokenKey)).thenReturn(tToken);
        when(() => mockPrefs.remove(tokenKey)).thenAnswer((_) async => true);

        tokenService.saveToken(tToken);
        verify(() => mockPrefs.setString(tokenKey, tToken)).called(1);

        final retrievedToken = tokenService.getToken();
        expect(retrievedToken, tToken);

        tokenService.removeToken();
        verify(() => mockPrefs.remove(tokenKey)).called(1);
      });
    });
  });
}
