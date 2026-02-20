// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartApiModel $CartApiModelFromJson(Map<String, dynamic> json) => CartApiModel(
      plantId: json['plantId'] == null
          ? null
          : PlantIdData.fromJson(json['plantId'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> $CartApiModelToJson(CartApiModel instance) =>
    <String, dynamic>{
      'plantId': instance.plantId,
      'quantity': instance.quantity,
      'price': instance.price,
    };

PlantIdData $PlantIdDataFromJson(Map<String, dynamic> json) => PlantIdData(
      sId: json['_id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      stock: (json['stock'] as num?)?.toInt(),
      plantImage: json['plantImage'] as List<dynamic>?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> $PlantIdDataToJson(PlantIdData instance) =>
    <String, dynamic>{
      '_id': instance.sId,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'price': instance.price,
      'stock': instance.stock,
      'plantImage': instance.plantImage,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
