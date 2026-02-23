
import 'package:nurser_e/features/orders/data/models/order_api_model.dart';

abstract interface class IOrderRemoteDatasource {
  Future<List<OrderApiModel>> getOrders();
  
}
