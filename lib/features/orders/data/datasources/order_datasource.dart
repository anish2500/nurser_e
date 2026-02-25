import 'package:nurser_e/features/orders/data/models/order_api_model.dart';


abstract interface class IOrderRemoteDataSource {
  Future<List<OrderApiModel>> getOrders();
  Future<OrderApiModel> getOrderById(String orderId);
  Future<OrderApiModel> cancelOrder(String orderId);
}
