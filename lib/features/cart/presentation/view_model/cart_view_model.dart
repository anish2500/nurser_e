import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/features/cart/data/repositories/cart_repository.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';
import 'package:nurser_e/features/cart/domain/repositories/cart_repository.dart';
import 'package:nurser_e/features/cart/presentation/state/cart_state.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';

final cartViewModelProvider = NotifierProvider<CartViewModel, CartState>(
  () => CartViewModel(),
);

class CartViewModel extends Notifier<CartState> {
  late final CartRepository _repository;
  @override
  CartState build() {
    _repository = ref.read(cartRepositoryProvider);
    return CartState.initial();
  }

  Future<void> loadCart() async {
    state = state.copyWith(status: CartStatus.loading);
    try {
      final items = await _repository.getCart();
      state = state.copyWith(status: CartStatus.loaded, items: items);
    } catch (e) {
      state = state.copyWith(
        status: CartStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> addToCart(PlantEntity plant) async {
    final cartItem = CartItemEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      plantId: plant.id,
      plantName: plant.name,
      plantImage: plant.plantImages.isNotEmpty ? plant.plantImages.first : '',
      price: plant.price,
      quantity: 1,
    );
    try {
      await _repository.addToCart(cartItem);
      await loadCart();
    } catch (e) {
      state = state.copyWith(
        status: CartStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateQuantity(String plantId, int quantity) async {
    if (quantity < 1) return;
    try {
      await _repository.updateQuantity(plantId, quantity);
      await loadCart();
    } catch (e) {
      state = state.copyWith(
        status: CartStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> removeFromCart(String plantId) async {
    try {
      await _repository.removeFromCart(plantId);
      await loadCart();
    } catch (e) {
      state = state.copyWith(
        status: CartStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> clearCart() async {
    try {
      await _repository.clearCart();
      state = CartState.initial();
    } catch (e) {
      state = state.copyWith(
        status: CartStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<Map<String, dynamic>> checkout() async {
    state = state.copyWith(status: CartStatus.loading);
    try {
      final items = state.items;
      final totalAmount = state.totalAmount;
      final response = await _repository.checkout(items: items, totalAmount: totalAmount);
      state = CartState.initial();
      return response;
    } catch (e) {
      state = state.copyWith(
        status: CartStatus.error,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }
}
