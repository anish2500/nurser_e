//step 3 is to create a repository in the domain

import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<List<CartItemEntity>> getCart();
  Future<CartItemEntity> addToCart(CartItemEntity item);
  Future<CartItemEntity> updateQuantity(String plantId, int quantity);
  Future<void> removeFromCart(String plantId);
  Future<void> clearCart();
  Future<Map<String, dynamic>> checkout({required List<CartItemEntity> items, required double totalAmount});
}
