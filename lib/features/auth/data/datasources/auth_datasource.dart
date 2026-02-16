import 'dart:io';

import 'package:nurser_e/features/auth/data/models/auth_api_model.dart';
import 'package:nurser_e/features/auth/data/models/auth_hive_model.dart';
import 'package:nurser_e/features/auth/domain/entities/auth_entity.dart';
import 'package:nurser_e/features/auth/domain/usecases/update_profile_usecase.dart';

abstract interface class IAuthLocalDataSource {
  Future<AuthHiveModel> register(AuthHiveModel model);
  Future<AuthHiveModel?> login(String email, String password);
  Future<AuthHiveModel?> getCurrentUser();
  Future<bool> logout();

  // Added to support Repository methods
  Future<AuthHiveModel?> getUserById(String authId);
  Future<AuthHiveModel?> getUserByEmail(String email);
  Future<bool> updateUser(AuthHiveModel model);
  Future<bool> deleteUser(String authId);

  // Email check
  Future<bool> isEmailExists(String email);

  // Update profile picture
  Future<bool> updateProfilePicture(String userId, String profileImage);
}

abstract interface class IAuthRemoteDataSource {
  Future<AuthApiModel> register(AuthApiModel user);
  Future<AuthApiModel?> login(String email, String password);
  Future<AuthApiModel?> getUserById(String authId);
  Future<String> uploadImage(File image);
  Future<AuthEntity> updateProfile(UpdateProfileParams params);
}
