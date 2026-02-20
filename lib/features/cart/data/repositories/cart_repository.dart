//after remote_datasource this is the next step repositories/cart_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/features/cart/data/datasources/remote/cart_remote_datasource.dart';
import 'package:nurser_e/features/cart/data/models/cart_api_model.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';
import 'package:nurser_e/features/cart/domain/repositories/cart_repository.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl(
    remoteDatasource: ref.read(cartRemoteDatasourceProvider),
  );
});

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDatasource remoteDatasource;

  CartRepositoryImpl({required this.remoteDatasource});
  @override
  Future<CartItemEntity> addToCart(CartItemEntity item) async {
    final model = await remoteDatasource.addToCart(
      plantId: item.plantId,
      plantName: item.plantName,
      plantImage: item.plantImage,
      price: item.price,
      quantity: item.quantity,
    );
    return model.toEntity();
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
    await remoteDatasource.clearCart();
  }

  @override
  Future<List<CartItemEntity>> getCart() async {
    final models = await remoteDatasource.getCart();
    return CartApiModel.toEntityList(models);
  }

  @override
  Future<void> removeFromCart(String plantId) async {
    await remoteDatasource.removeFromCart(plantId);
  }

  @override
  Future<CartItemEntity> updateQuantity(String plantId, int quantity) async {
    final model = await remoteDatasource.updateCartItem(plantId, quantity);
    return model.toEntity();
  }
}
