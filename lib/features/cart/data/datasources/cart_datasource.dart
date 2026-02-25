import 'package:nurser_e/features/cart/data/models/cart_api_model.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';

abstract interface class ICartLocalDatasource {
  List<CartItemEntity> getCart();
  Future<void> addToCart(CartItemEntity item);
  Future<void> updateCartItem(String cartItemId, int quantity);
  Future<void> removeFromCart(String cartItemId);
  Future<void> clearCart();
}

abstract interface class ICartRemoteDatasource {
  Future<List<CartApiModel>> getCart();
  Future<CartApiModel> addToCart({
    required String plantId,
    required String plantName,
    required String plantImage,
    required double price,
    int quantity = 1,
  });
  Future<CartApiModel> updateCartItem(String plantId, int quantity);
  Future<void> removeFromCart(String plantId);
  Future<void> clearCart();
  Future<Map<String, dynamic>> checkout({
    required List<Map<String, dynamic>> items,
    required double totalAmount,
  });
}
