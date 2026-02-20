import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';
part 'cart_api_model.g.dart';
@JsonSerializable()
class CartApiModel {
  @JsonKey(name: 'plantId')
  final PlantIdData? plantId;
  final int? quantity;
  final double? price;
  CartApiModel({
    this.plantId,
    this.quantity,
    this.price,
  });
  factory CartApiModel.fromJson(Map<String, dynamic> json) {
    return CartApiModel(
      plantId: json['plantId'] != null 
          ? PlantIdData.fromJson(json['plantId']) 
          : null,
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
    );
  }
  Map<String, dynamic> toJson() => $CartApiModelToJson(this);
  CartItemEntity toEntity() {
    // Get plant image - handle null safely
    String imageUrl = '';
    if (plantId?.plantImage != null && plantId!.plantImage!.isNotEmpty) {
      imageUrl = plantId!.plantImage!.first;
    }
    
    return CartItemEntity(
      id: plantId?.sId ?? '',
      plantId: plantId?.sId ?? '',
      plantName: plantId?.name ?? 'Unknown Plant',
      plantImage: imageUrl,
      price: price ?? 0.0,
      quantity: quantity ?? 1,
    );
  }
  static List<CartItemEntity> toEntityList(List<CartApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
@JsonSerializable()
class PlantIdData {
  @JsonKey(name: '_id')
  final String? sId;
  final String? name;
  final String? description;
  final String? category;
  final double? price;
  final int? stock;
  final List<dynamic>? plantImage;
  final DateTime? createdAt;
  PlantIdData({
    this.sId,
    this.name,
    this.description,
    this.category,
    this.price,
    this.stock,
    this.plantImage,
    this.createdAt,
  });
  factory PlantIdData.fromJson(Map<String, dynamic> json) {
    return PlantIdData(
      sId: json['_id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      plantImage: json['plantImage'] as List<dynamic>?,
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt']) 
          : null,
    );
  }
}