import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/api/api_client.dart';
import 'package:nurser_e/core/api/api_endpoints.dart';
import 'package:nurser_e/features/orders/data/datasources/order_datasource.dart';
import 'package:nurser_e/features/orders/data/models/order_api_model.dart';

final orderRemoteDatasourceProvider = Provider<OrderRemoteDatasource>((ref) {
  return OrderRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class OrderRemoteDatasource implements IOrderRemoteDatasource {
  final ApiClient _apiClient;

  OrderRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<OrderApiModel>> getOrders() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.orders);

      if (response.data['success'] == true) {
        final data = response.data['data'] as List? ?? [];
        return data.map((json) => OrderApiModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      rethrow;
    }
  }

  Future<OrderApiModel> getOrderById(String orderId) async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.orders}/$orderId');

      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        return OrderApiModel.fromJson(data);
      }

      throw Exception('Failed to get order');
    } catch (e) {
      debugPrint('Error fetching order: $e');
      rethrow;
    }
  }
}
