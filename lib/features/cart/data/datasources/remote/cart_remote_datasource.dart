import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/api/api_client.dart';
import 'package:nurser_e/core/api/api_endpoints.dart';
import 'package:nurser_e/features/cart/data/models/cart_api_model.dart';

final cartRemoteDatasourceProvider = Provider<CartRemoteDatasource>((ref) {
  return CartRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class CartRemoteDatasource {
  final ApiClient _apiClient;
  CartRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Get cart items
  Future<List<CartApiModel>> getCart() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.cart);

      // Response is: { success: true, data: { items: [...] }, message: "..." }
      if (response.data['success'] == true) {
        final cartData = response.data['data'] as Map<String, dynamic>?;
        if (cartData == null) return [];

        final items = cartData['items'] as List? ?? [];
        return items.map((json) => CartApiModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error fetching cart: $e');
      rethrow;
    }
  }

  /// Add item to cart
  Future<CartApiModel> addToCart({
    required String plantId,
    required String plantName,
    required String plantImage,
    required double price,
    int quantity = 1,
  }) async {
    // final response = await _apiClient.post(
    //   ApiEndpoints.cart,
    //   data: {'plantId': plantId, 'quantity': quantity},
    // );

    // // Response: { success: true, data: { plantId: {...}, quantity: 1, price: 120 } }
    // return CartApiModel.fromJson(response.data['data']);

    try {
      final response = await _apiClient.post(
        ApiEndpoints.cart,
        data: {'plantId': plantId, 'quantity': quantity},
      );
      return CartApiModel.fromJson(response.data['data']);
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      rethrow; 
    }
  }

  /// Update cart item quantity
  Future<CartApiModel> updateCartItem(String plantId, int quantity) async {
    final response = await _apiClient.put(
      '${ApiEndpoints.cart}/$plantId',
      data: {'quantity': quantity},
    );

    return CartApiModel.fromJson(response.data['data']);
  }

  /// Remove item from cart
  Future<void> removeFromCart(String plantId) async {
    await _apiClient.delete('${ApiEndpoints.cart}/$plantId');
  }

  /// Clear cart
  Future<void> clearCart() async {
    await _apiClient.delete(ApiEndpoints.cart);
  }

  /// Checkout
  Future<Map<String, dynamic>> checkout({
    required List<Map<String, dynamic>> items,
    required double totalAmount,
  }) async {
    final response = await _apiClient.post(
      '/orders',
      data: {'items': items, 'totalAmount': totalAmount},
    );
    return response.data;
  }
}
