import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity entity);
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, AuthEntity>> getCurrentUser();
  Future<Either<Failure, bool>> logout();

  //image upload
  Future<Either<Failure, String>> uploadImage(File image);
  Future<Either<Failure, AuthEntity?>> getUserById(String authId);
  Future<Either<Failure, AuthEntity?>> getUserByEmail(String email);
  Future<Either<Failure, bool>> updateUser(AuthEntity entity);
  Future<Either<Failure, bool>> deleteUser(String authId);
  Future<bool> isEmailExists(String email);
}
