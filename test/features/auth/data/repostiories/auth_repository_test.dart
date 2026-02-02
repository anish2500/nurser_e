import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/services/connectivity/network_info.dart';
import 'package:nurser_e/features/auth/data/datasources/auth_datasource.dart';
import 'package:nurser_e/features/auth/data/models/auth_api_model.dart';
import 'package:nurser_e/features/auth/data/models/auth_hive_model.dart';
import 'package:nurser_e/features/auth/data/repositories/auth_repository.dart';
import 'package:nurser_e/features/auth/domain/entities/auth_entity.dart';



class MockAuthLocalDatasource extends Mock
    implements IAuthLocalDataSource {}

class MockAuthRemoteDatasource extends Mock
    implements IAuthRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class FakeFile extends Fake implements File {}

void main() {
  late AuthRepository repository;
  late MockAuthLocalDatasource mockLocalDatasource;
  late MockAuthRemoteDatasource mockRemoteDatasource;
  late MockNetworkInfo mockNetworkInfo;



  setUpAll(() {
    registerFallbackValue(FakeFile());

    registerFallbackValue(
      AuthApiModel(
        authId: '1',
        email: 'test@example.com',
        username: 'testuser',
        password: 'password123',
        profilePicture: null,
      ),
    );

    registerFallbackValue(
      AuthHiveModel(
        authId: '1',
        email: 'test@example.com',
        username: 'testuser',
        password: 'password123',
        profilePicture: null,
      ),
    );
  });

  setUp(() {
    mockLocalDatasource = MockAuthLocalDatasource();
    mockRemoteDatasource = MockAuthRemoteDatasource();
    mockNetworkInfo = MockNetworkInfo();

    repository = AuthRepository(
      authLocalDatasource: mockLocalDatasource,
      authRemoteDataSource: mockRemoteDatasource,
      networkInfo: mockNetworkInfo,
    );
  });



  const tAuthEntity = AuthEntity(
    authId: '1',
    email: 'test@example.com',
    username: 'testuser',
    password: 'password123',
    profilePicture: null,
  );

  final tAuthApiModel = AuthApiModel(
    authId: '1',
    email: 'test@example.com',
    username: 'testuser',
    password: null,
    profilePicture: null,
  );

  final tAuthHiveModel = AuthHiveModel(
    authId: '1',
    email: 'test@example.com',
    username: 'testuser',
    password: 'password123',
    profilePicture: null,
  );



  group('register', () {
    test('returns Right(true) when online and registration succeeds', () async {
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.register(any()))
          .thenAnswer((_) async => tAuthApiModel);

      final result = await repository.register(tAuthEntity);

      expect(result, const Right(true));
      verify(() => mockRemoteDatasource.register(any())).called(1);
    });

    test('returns ApiFailure when online and DioException occurs', () async {
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.register(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/register'),
          response: Response(
            requestOptions: RequestOptions(path: '/register'),
            statusCode: 400,
            data: {'message': 'Registration Failed'},
          ),
        ),
      );

      final result = await repository.register(tAuthEntity);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ApiFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('registers locally when offline and email does not exist', () async {
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getUserByEmail(any()))
          .thenAnswer((_) async => null);
      when(() => mockLocalDatasource.register(any()))
          .thenAnswer((_) async => tAuthHiveModel);

      final result = await repository.register(tAuthEntity);

      expect(result, const Right(true));
      verify(() => mockLocalDatasource.register(any())).called(1);
      verifyNever(() => mockRemoteDatasource.register(any()));
    });

    test('returns LocalDatabaseFailure when offline and email exists', () async {
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getUserByEmail(any()))
          .thenAnswer((_) async => tAuthHiveModel);

      final result = await repository.register(tAuthEntity);

      expect(result.isLeft(), true);
      result.fold(
        (failure) =>
            expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Expected failure'),
      );
    });
  });


  group('login', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';

    test('returns AuthEntity when online login succeeds', () async {
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.login(tEmail, tPassword))
          .thenAnswer((_) async => tAuthApiModel);

      final result = await repository.login(tEmail, tPassword);

      expect(result.isRight(), true);
    });

    test('returns ApiFailure when online and credentials invalid', () async {
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.login(tEmail, tPassword))
          .thenAnswer((_) async => null);

      final result = await repository.login(tEmail, tPassword);

      expect(result.isLeft(), true);
    });

    test('returns AuthEntity when offline and local login succeeds', () async {
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => false);
      when(() => mockLocalDatasource.login(tEmail, tPassword))
          .thenAnswer((_) async => tAuthHiveModel);

      final result = await repository.login(tEmail, tPassword);

      expect(result.isRight(), true);
      verifyNever(() => mockRemoteDatasource.login(any(), any()));
    });

    test('returns LocalDatabaseFailure when offline and credentials invalid',
        () async {
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => false);
      when(() => mockLocalDatasource.login(tEmail, tPassword))
          .thenAnswer((_) async => null);

      final result = await repository.login(tEmail, tPassword);

      expect(result.isLeft(), true);
    });
  });


  group('uploadImage', () {
    test('returns filename when online', () async {
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.uploadImage(any()))
          .thenAnswer((_) async => 'profile.png');

      final result = await repository.uploadImage(File('test.png'));

      expect(result, const Right('profile.png'));
    });

    test('returns ApiFailure when offline', () async {
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => false);

      final result = await repository.uploadImage(File('test.png'));

      expect(result.isLeft(), true);
    });
  });
}
