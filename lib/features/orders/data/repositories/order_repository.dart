import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/features/orders/data/datasources/remote/order_remote_datasource.dart';
import 'package:nurser_e/features/orders/data/models/order_api_model.dart';
import 'package:nurser_e/features/orders/domain/entities/order_entity.dart';
import 'package:nurser_e/features/orders/domain/repositories/order_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(
    remoteDatasource: ref.read(orderRemoteDatasourceProvider),
  );
});

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDatasource remoteDatasource;

  OrderRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<OrderEntity>> getOrders() async {
    final models = await remoteDatasource.getOrders();
    return OrderApiModel.toEntityList(models);
  }

  @override
  Future<OrderEntity> getOrderById(String orderId) async {
    final model = await remoteDatasource.getOrderById(orderId);
    return model.toEntity();
  }
}
