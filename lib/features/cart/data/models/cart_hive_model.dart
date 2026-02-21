import 'package:hive/hive.dart';
import 'package:nurser_e/core/constants/hive_table_constant.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';

part 'cart_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.cartTypeId)
class CartHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String plantId;

  @HiveField(2)
  final String plantName;

  @HiveField(3)
  final String plantImage;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final int quantity;

  CartHiveModel({
    required this.id,
    required this.plantId,
    required this.plantName,
    required this.plantImage,
    required this.price,
    required this.quantity,
  });

  CartItemEntity toEntity() {
    return CartItemEntity(
      id: id,
      plantId: plantId,
      plantName: plantName,
      plantImage: plantImage,
      price: price,
      quantity: quantity,
    );
  }

  factory CartHiveModel.fromEntity(CartItemEntity entity) {
    return CartHiveModel(
      id: entity.id,
      plantId: entity.plantId,
      plantName: entity.plantName,
      plantImage: entity.plantImage,
      price: entity.price,
      quantity: entity.quantity,
    );
  }

  static List<CartItemEntity> toEntityList(List<CartHiveModel> models) {
    return models.map((e) => e.toEntity()).toList();
  }
}
