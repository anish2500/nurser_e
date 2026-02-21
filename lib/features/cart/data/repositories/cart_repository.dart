//after remote_datasource this is the next step repositories/cart_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/services/hive/hive_service.dart';
import 'package:nurser_e/features/cart/data/datasources/remote/cart_remote_datasource.dart';
import 'package:nurser_e/features/cart/data/models/cart_api_model.dart';
import 'package:nurser_e/features/cart/data/models/cart_hive_model.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';
import 'package:nurser_e/features/cart/domain/repositories/cart_repository.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl(
    remoteDatasource: ref.read(cartRemoteDatasourceProvider),
    hiveService: ref.read(hiveServiceProvider),
  );
});

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDatasource remoteDatasource;
  final HiveService hiveService;

  CartRepositoryImpl({
    required this.remoteDatasource,
    required this.hiveService,
  });
  @override
  Future<CartItemEntity> addToCart(CartItemEntity item) async {
    final hiveModel = CartHiveModel.fromEntity(item);
    await hiveService.addToCart(hiveModel);
    try {
      final model = await remoteDatasource.addToCart(
        plantId: item.plantId,
        plantName: item.plantName,
        plantImage: item.plantImage,
        price: item.price,
        quantity: item.quantity,
      );
      return model.toEntity();
    } catch (e) {
      // Return local item if offline
      return item;
    }
  }

  @override
  Future<Map<String, dynamic>> checkout({
    required List<CartItemEntity> items,
    required double totalAmount,
  }) async {
    final itemsData = items
        .map(
          (item) => {
            'plantId': item.plantId,
            'quantity': item.quantity,
            'price': item.price,
          },
        )
        .toList();

    final response = await remoteDatasource.checkout(
      items: itemsData,
      totalAmount: totalAmount,
    );
    return response;
  }

  @override
  Future<void> clearCart() async {
    await hiveService.clearCart();
    try {
      await remoteDatasource.clearCart();
    } catch (e) {
      // Already cleared locally
    }
  }

  @override
  Future<List<CartItemEntity>> getCart() async {
    try {
      
      final models = await remoteDatasource.getCart();
      await hiveService.clearCart();
      final entities = CartApiModel.toEntityList(models);

      for (var entity in entities) {
        await hiveService.addToCart(CartHiveModel.fromEntity(entity));
      }
      return entities;
    } catch (e) {
      return CartHiveModel.toEntityList(hiveService.getCartItems());
    }
  }

  @override
  Future<void> removeFromCart(String plantId) async {
    final items = hiveService.getCartItems();
    final item = items.where((i) => i.plantId == plantId).firstOrNull;
    if (item != null) {
      await hiveService.removeFromCart(item.id);
    }

    try {
      await remoteDatasource.removeFromCart(plantId);
    } catch (e) {
      //
    }
  }

  @override
  Future<CartItemEntity> updateQuantity(String plantId, int quantity) async {
    final items = hiveService.getCartItems();
    final item = items.where((i) => i.plantId == plantId).firstOrNull;

    if (item != null) {
      final updated = CartHiveModel(
        id: item.id,
        plantId: item.plantId,
        plantName: item.plantName,
        plantImage: item.plantImage,
        price: item.price,
        quantity: quantity,
      );
      await hiveService.updateCartItem(updated);
    }
    try {
      final model = await remoteDatasource.updateCartItem(plantId, quantity);
      return model.toEntity();
    } catch (e) {
      return CartItemEntity(
        id: item?.id ?? '',
        plantId: plantId,
        plantName: item?.plantName ?? '',
        plantImage: item?.plantImage ?? '',
        price: item?.price ?? 0,
        quantity: quantity,
      );
    }
  }
}
