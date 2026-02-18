// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantApiModel _$PlantApiModelFromJson(Map<String, dynamic> json) =>
    PlantApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      plantImages: (json['plantImage'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      stock: (json['stock'] as num).toInt(),
    );

Map<String, dynamic> _$PlantApiModelToJson(PlantApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'price': instance.price,
      'plantImage': instance.plantImages,
      'createdAt': instance.createdAt?.toIso8601String(),
      'stock': instance.stock,
    };
