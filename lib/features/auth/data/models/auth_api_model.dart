import 'package:nurser_e/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? authId;
  final String email;
  final String username;
  final String? password;
  final String? profilePicture;

  AuthApiModel({
    this.authId,
    required this.email,
    required this.username,
    this.password,
    this.profilePicture,
  });

  //to Json

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "username": username,
      "password" : password, 
      "profilePicture": profilePicture,
    };
  }

  // fromJson

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      authId: json['_id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      profilePicture: json['profilePicture'] as String?,
    );
  }

  //toEntity

  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      email: email,
      username: username,
      profilePicture: profilePicture,
    );
  }

  //fromEntity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      email: entity.email,
      username: entity.username,
      password: entity.password,
      profilePicture: entity.profilePicture,
    );
  }

  //toEntityList

  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
