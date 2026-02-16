import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/api/api_client.dart';
import 'package:nurser_e/core/api/api_endpoints.dart';
import 'package:nurser_e/core/services/storage/token_service.dart';
import 'package:nurser_e/core/services/storage/user_session_service.dart';
import 'package:nurser_e/features/auth/data/datasources/auth_datasource.dart';
import 'package:nurser_e/features/auth/data/models/auth_api_model.dart';
import 'package:nurser_e/features/auth/domain/entities/auth_entity.dart';
import 'package:nurser_e/features/auth/domain/usecases/update_profile_usecase.dart';

final authRemoteDatasourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService,
       _tokenService = tokenService;

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final user = AuthApiModel.fromJson(data);

      await _userSessionService.saveUserSession(
        userId: user.authId!,
        email: user.email,
        username: user.username,
        profileImage: user.profilePicture ?? '',
      );

      //save token
      final token = response.data['token'] as String?;
      await _tokenService.saveToken(token!);

      return user;
    }

    return null;
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = AuthApiModel.fromJson(data);
      return registeredUser;
    }

    return user;
  }

  @override
  Future<AuthApiModel?> getUserById(String authId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<String> uploadImage(File image) async {
    try {
      // Create multipart request for file upload
      final formData = FormData.fromMap({
        'profilePicture': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });

      final response = await _apiClient.put(
        ApiEndpoints.userProfile, // '/auth/profile'
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200) {
        // Get the actual image path from response data
        final imagePath =
            response.data['data']?['profilePicture'] ??
            response.data['profilePicture'];
        return imagePath ?? "Profile updated successfully";
      } else {
        return "Failed to update profile";
      }
    } on DioException catch (e) {
      throw Exception(
        "Server Error: ${e.response?.data['message'] ?? e.message}",
      );
    } catch (e) {
      throw Exception("Unexpected Error: $e");
    }
  }

  @override
  Future<AuthEntity> updateProfile(UpdateProfileParams params) async {
    try {
      final formData = FormData();
      if (params.username != null) {
        formData.fields.add(MapEntry('username', params.username!));
      }
      if (params.email != null) {
        formData.fields.add(MapEntry('email', params.email!));
      }
      if (params.profilePicture != null) {
        formData.files.add(
          MapEntry(
            'profilePicture',
            await MultipartFile.fromFile(
              params.profilePicture!.path,
              filename: params.profilePicture!.path.split('/').last,
            ),
          ),
        );
      }
      final response = await _apiClient.put(
        ApiEndpoints.userProfile,
        data: formData,
      );
      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        final user = AuthApiModel.fromJson(data);

        // Update local storage
        await _userSessionService.saveUserSession(
          userId: user.authId!,
          email: user.email,
          username: user.username,
          profileImage: user.profilePicture ?? '',
        );

        return user.toEntity();
      } else {
        throw Exception('Failed to update profile');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
