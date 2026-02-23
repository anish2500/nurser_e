import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nurser_e/features/orders/domain/entities/order_entity.dart';

part 'order_api_model.g.dart';

@JsonSerializable()
class OrderApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? userId;
  final List<OrderItem>? items;
  final double? totalAmount;
  final String? paymentMethod;
  final String? orderStatus;
  final String? paymentStatus;
  final String? transactionId;
  final DateTime? createdAt;

  OrderApiModel({
    this.id,
    this.userId,
    this.items,
    this.totalAmount,
    this.paymentMethod,
    this.orderStatus,
    this.paymentStatus,
    this.transactionId,
    this.createdAt,
  });

  factory OrderApiModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    final orderItems = itemsList.map((item) {
      if (item is Map<String, dynamic>) {
        return OrderItem.fromJson(item);
      }
      return OrderItem();
    }).toList();
    
    return OrderApiModel(
      id: json['_id'],
      userId: json['userId'],
      items: orderItems,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      paymentMethod: json['paymentMethod'],
      orderStatus: json['orderStatus'],
      paymentStatus: json['paymentStatus'],
      transactionId: json['transactionId'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }
  
  Map<String, dynamic> toJson() => _$OrderApiModelToJson(this);

  OrderEntity toEntity() {
    return OrderEntity(
      id: id ?? '',
      userId: userId ?? '',
      items: items?.map((item) => item.toEntity()).toList() ?? [],
      totalAmount: totalAmount?.toDouble() ?? 0.0,
      paymentMethod: paymentMethod ?? 'cash_on_delivery',
      orderStatus: orderStatus ?? 'pending',
      paymentStatus: paymentStatus ?? 'pending',
      transactionId: transactionId,
      createdAt: createdAt,
    );
  }

  static List<OrderEntity> toEntityList(List<OrderApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}

@JsonSerializable()
class OrderItem {
  @JsonKey(name: '_id')
  final String? id;
  final PlantData? plantId;
  final int? quantity;
  final double? price;

  OrderItem({
    this.id,
    this.plantId,
    this.quantity,
    this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['_id'],
      plantId: json['plantId'] != null 
          ? PlantData.fromJson(json['plantId'] as Map<String, dynamic>)
          : null,
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
    );
  }
  
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  OrderItemEntity toEntity() {
    String imageUrl = '';
    if (plantId?.plantImage != null && plantId!.plantImage!.isNotEmpty) {
      imageUrl = plantId!.plantImage!.first.toString();
    }
    
    return OrderItemEntity(
      id: id ?? '',
      plantId: plantId?.sId ?? '',
      plantName: plantId?.name ?? 'Unknown Plant',
      plantImage: imageUrl,
      price: price ?? 0.0,
      quantity: quantity ?? 1,
    );
  }
}

@JsonSerializable()
class PlantData {
  @JsonKey(name: '_id')
  final String? sId;
  final String? name;
  final double? price;
  final List<dynamic>? plantImage;

  PlantData({
    this.sId,
    this.name,
    this.price,
    this.plantImage,
  });

  factory PlantData.fromJson(Map<String, dynamic> json) =>
      _$PlantDataFromJson(json);
  Map<String, dynamic> toJson() => _$PlantDataToJson(this);
}
