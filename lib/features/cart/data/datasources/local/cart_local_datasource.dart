import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/services/hive/hive_service.dart';
import 'package:nurser_e/features/cart/data/models/cart_hive_model.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';
final cartLocalDatasourceProvider = Provider<CartLocalDatasource>((ref) {
  return CartLocalDatasource(ref.read(hiveServiceProvider));
});
class CartLocalDatasource {
  final HiveService _hiveService;
  CartLocalDatasource(this._hiveService);
  List<CartItemEntity> getCart() {
    return CartHiveModel.toEntityList(_hiveService.getCartItems());
  }
  Future<void> addToCart(CartItemEntity item) async {
    await _hiveService.addToCart(CartHiveModel.fromEntity(item));
  }
  Future<void> updateCartItem(String cartItemId, int quantity) async {
    final items = _hiveService.getCartItems();
    final index = items.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      final item = items[index];
      final updated = CartHiveModel(
        id: item.id,
        plantId: item.plantId,
        plantName: item.plantName,
        plantImage: item.plantImage,
        price: item.price,
        quantity: quantity,
      );
      await _hiveService.updateCartItem(updated);
    }
  }
  Future<void> removeFromCart(String cartItemId) async {
    await _hiveService.removeFromCart(cartItemId);
  }
  Future<void> clearCart() async {
    await _hiveService.clearCart();
  }
}