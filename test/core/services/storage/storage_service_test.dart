import 'package:flutter_test/flutter_test.dart';
import 'package:nurser_e/core/services/storage/storage_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late StorageService storageService;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    storageService = StorageService(prefs: mockPrefs);
  });

  const tKey = 'test_key';

  group('StorageService', () {
    group('String operations', () {
      const tStringValue = 'test_value';

      test('setString should save string value', () async {
        when(() => mockPrefs.setString(tKey, tStringValue))
            .thenAnswer((_) async => true);

        final result = await storageService.setString(tKey, tStringValue);

        expect(result, true);
        verify(() => mockPrefs.setString(tKey, tStringValue)).called(1);
      });

      test('getString should return string value when it exists', () {
        when(() => mockPrefs.getString(tKey)).thenReturn(tStringValue);

        final result = storageService.getString(tKey);

        expect(result, tStringValue);
        verify(() => mockPrefs.getString(tKey)).called(1);
      });

      test('getString should return null when key does not exist', () {
        when(() => mockPrefs.getString(tKey)).thenReturn(null);

        final result = storageService.getString(tKey);

        expect(result, isNull);
      });
    });

    group('Int operations', () {
      const tIntValue = 42;

      test('setInt should save int value', () async {
        when(() => mockPrefs.setInt(tKey, tIntValue))
            .thenAnswer((_) async => true);

        final result = await storageService.setInt(tKey, tIntValue);

        expect(result, true);
        verify(() => mockPrefs.setInt(tKey, tIntValue)).called(1);
      });

      test('getInt should return int value when it exists', () {
        when(() => mockPrefs.getInt(tKey)).thenReturn(tIntValue);

        final result = storageService.getInt(tKey);

        expect(result, tIntValue);
      });

      test('getInt should return null when key does not exist', () {
        when(() => mockPrefs.getInt(tKey)).thenReturn(null);

        final result = storageService.getInt(tKey);

        expect(result, isNull);
      });
    });

    group('Double operations', () {
      const tDoubleValue = 3.14;

      test('setDouble should save double value', () async {
        when(() => mockPrefs.setDouble(tKey, tDoubleValue))
            .thenAnswer((_) async => true);

        final result = await storageService.setDouble(tKey, tDoubleValue);

        expect(result, true);
        verify(() => mockPrefs.setDouble(tKey, tDoubleValue)).called(1);
      });

      test('getDouble should return double value when it exists', () {
        when(() => mockPrefs.getDouble(tKey)).thenReturn(tDoubleValue);

        final result = storageService.getDouble(tKey);

        expect(result, tDoubleValue);
      });

      test('getDouble should return null when key does not exist', () {
        when(() => mockPrefs.getDouble(tKey)).thenReturn(null);

        final result = storageService.getDouble(tKey);

        expect(result, isNull);
      });
    });

    group('Bool operations', () {
      const tBoolValue = true;

      test('setBool should save bool value', () async {
        when(() => mockPrefs.setBool(tKey, tBoolValue))
            .thenAnswer((_) async => true);

        final result = await storageService.setBool(tKey, tBoolValue);

        expect(result, true);
        verify(() => mockPrefs.setBool(tKey, tBoolValue)).called(1);
      });

      test('getBool should return bool value when it exists', () {
        when(() => mockPrefs.getBool(tKey)).thenReturn(tBoolValue);

        final result = storageService.getBool(tKey);

        expect(result, tBoolValue);
      });

      test('getBool should return null when key does not exist', () {
        when(() => mockPrefs.getBool(tKey)).thenReturn(null);

        final result = storageService.getBool(tKey);

        expect(result, isNull);
      });
    });

    group('StringList operations', () {
      final tStringList = ['item1', 'item2', 'item3'];

      test('setStringList should save string list', () async {
        when(() => mockPrefs.setStringList(tKey, tStringList))
            .thenAnswer((_) async => true);

        final result = await storageService.setStringList(tKey, tStringList);

        expect(result, true);
        verify(() => mockPrefs.setStringList(tKey, tStringList)).called(1);
      });

      test('getStringList should return list when it exists', () {
        when(() => mockPrefs.getStringList(tKey)).thenReturn(tStringList);

        final result = storageService.getStringList(tKey);

        expect(result, tStringList);
      });

      test('getStringList should return null when key does not exist', () {
        when(() => mockPrefs.getStringList(tKey)).thenReturn(null);

        final result = storageService.getStringList(tKey);

        expect(result, isNull);
      });
    });

    group('remove', () {
      test('should remove key from SharedPreferences', () async {
        when(() => mockPrefs.remove(tKey)).thenAnswer((_) async => true);

        final result = await storageService.remove(tKey);

        expect(result, true);
        verify(() => mockPrefs.remove(tKey)).called(1);
      });
    });

    group('clear', () {
      test('should clear all SharedPreferences', () async {
        when(() => mockPrefs.clear()).thenAnswer((_) async => true);

        final result = await storageService.clear();

        expect(result, true);
        verify(() => mockPrefs.clear()).called(1);
      });
    });

    group('containsKey', () {
      test('should return true when key exists', () {
        when(() => mockPrefs.containsKey(tKey)).thenReturn(true);

        final result = storageService.containsKey(tKey);

        expect(result, true);
        verify(() => mockPrefs.containsKey(tKey)).called(1);
      });

      test('should return false when key does not exist', () {
        when(() => mockPrefs.containsKey(tKey)).thenReturn(false);

        final result = storageService.containsKey(tKey);

        expect(result, false);
      });
    });
  });
}
