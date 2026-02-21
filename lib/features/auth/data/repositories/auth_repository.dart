import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/services/connectivity/network_info.dart';
import 'package:nurser_e/features/auth/data/datasources/auth_datasource.dart';
import 'package:nurser_e/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:nurser_e/features/auth/data/datasources/remote/auth_remote_datasource.dart'; // Ensure this exists
import 'package:nurser_e/features/auth/data/models/auth_api_model.dart'; // Ensure this exists
import 'package:nurser_e/features/auth/data/models/auth_hive_model.dart';
import 'package:nurser_e/features/auth/domain/entities/auth_entity.dart';
import 'package:nurser_e/features/auth/domain/repositories/auth_repository.dart';
import 'package:nurser_e/features/auth/domain/usecases/update_profile_usecase.dart';

// Provider for AuthRepository
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authLocalDataSource = ref.read(authLocalDatasourceProvider);
  final authRemoteDataSource = ref.read(authRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return AuthRepository(
    authLocalDatasource: authLocalDataSource,
    authRemoteDataSource: authRemoteDataSource,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDataSource _authLocalDataSource;
  final IAuthRemoteDataSource _authRemoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthLocalDataSource authLocalDatasource,
    required IAuthRemoteDataSource authRemoteDataSource,
    required NetworkInfo networkInfo,
  }) : _authLocalDataSource = authLocalDatasource,
       _authRemoteDataSource = authRemoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final user = await _authLocalDataSource.getCurrentUser();
      if (user != null) {
        return Right(user.toEntity());
      }
      return const Left(LocalDatabaseFailure(message: 'No user logged in'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDataSource.login(email, password);
        if (apiModel != null) {
          // Success: Return the entity
          return Right(apiModel.toEntity());
        }
        return const Left(ApiFailure(message: 'Invalid Credentials'));
      } on DioException catch (e) {
        return Left(
          ApiFailure(message: e.response?.data['message'] ?? 'Login Failed'),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      // Offline: Try logging in from Local Hive DB
      return const Left(
        ApiFailure(message: 'No internet connection. Please login when online'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(entity);
        await _authRemoteDataSource.register(apiModel);
        return const Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Registration Failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      // Offline: Save user locally
      try {
        final existingUser = await _authLocalDataSource.getUserByEmail(
          entity.email,
        );
        if (existingUser != null) {
          return const Left(
            LocalDatabaseFailure(message: 'Email already Registered'),
          );
        }

        final authModel = AuthHiveModel.fromEntity(entity);
        await _authLocalDataSource.register(authModel);
        return const Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authLocalDataSource.logout();
      if (result) {
        return const Right(true);
      }
      return const Left(LocalDatabaseFailure(message: "Failed to logout"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isEmailExists(String email) async {
    try {
      return await _authLocalDataSource.isEmailExists(email);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUser(String authId) async {
    try {
      final result = await _authLocalDataSource.deleteUser(authId);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity?>> getUserByEmail(String email) async {
    try {
      final user = await _authLocalDataSource.getUserByEmail(email);
      return Right(user?.toEntity());
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity?>> getUserById(String authId) async {
    try {
      final user = await _authLocalDataSource.getUserById(authId);
      return Right(user?.toEntity());
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateUser(AuthEntity entity) async {
    try {
      final model = AuthHiveModel.fromEntity(entity);
      final result = await _authLocalDataSource.updateUser(model);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(File image) async {
    if (await _networkInfo.isConnected) {
      try {
        final fileName = await _authRemoteDataSource.uploadImage(image);
        return Right(fileName);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> updateProfile(
    UpdateProfileParams params,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _authRemoteDataSource.updateProfile(params);
        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet connection'));
    }
  }
}
