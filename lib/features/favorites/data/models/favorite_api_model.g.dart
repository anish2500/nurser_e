// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteApiModel _$FavoriteApiModelFromJson(Map<String, dynamic> json) =>
    FavoriteApiModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      plants: (json['plants'] as List<dynamic>)
          .map((e) => PlantApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FavoriteApiModelToJson(FavoriteApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'plants': instance.plants,
    };
