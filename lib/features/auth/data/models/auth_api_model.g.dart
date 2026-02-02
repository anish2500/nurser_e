// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthApiModel _$AuthApiModelFromJson(Map<String, dynamic> json) => AuthApiModel(
      authId: json['_id'] as String?,
      email: json['email'] as String,
      username: json['username'] as String,
      password: json['password'] as String?,
      profilePicture: json['profilePicture'] as String?,
    );

Map<String, dynamic> _$AuthApiModelToJson(AuthApiModel instance) =>
    <String, dynamic>{
      '_id': instance.authId,
      'email': instance.email,
      'username': instance.username,
      'password': instance.password,
      'profilePicture': instance.profilePicture,
    };
