// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderApiModel _$OrderApiModelFromJson(Map<String, dynamic> json) =>
    OrderApiModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      paymentMethod: json['paymentMethod'] as String?,
      orderStatus: json['orderStatus'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      transactionId: json['transactionId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$OrderApiModelToJson(OrderApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'items': instance.items,
      'totalAmount': instance.totalAmount,
      'paymentMethod': instance.paymentMethod,
      'orderStatus': instance.orderStatus,
      'paymentStatus': instance.paymentStatus,
      'transactionId': instance.transactionId,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      id: json['_id'] as String?,
      plantId: json['plantId'] == null
          ? null
          : PlantData.fromJson(json['plantId'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      '_id': instance.id,
      'plantId': instance.plantId,
      'quantity': instance.quantity,
      'price': instance.price,
    };

PlantData _$PlantDataFromJson(Map<String, dynamic> json) => PlantData(
      sId: json['_id'] as String?,
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      plantImage: json['plantImage'] as List<dynamic>?,
    );

Map<String, dynamic> _$PlantDataToJson(PlantData instance) => <String, dynamic>{
      '_id': instance.sId,
      'name': instance.name,
      'price': instance.price,
      'plantImage': instance.plantImage,
    };
