import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/features/orders/data/repositories/order_repository.dart';
import 'package:nurser_e/features/orders/domain/repositories/order_repository.dart';
import 'package:nurser_e/features/orders/presentation/state/order_state.dart';

final orderViewModelProvider = NotifierProvider<OrderViewModel, OrderState>(
  () => OrderViewModel(),
);

class OrderViewModel extends Notifier<OrderState> {
  late final OrderRepository _repository;

  @override
  OrderState build() {
    _repository = ref.read(orderRepositoryProvider);
    return OrderState.initial();
  }

  Future<void> loadOrders() async {
    state = state.copyWith(status: OrderStatus.loading);
    try {
      final orders = await _repository.getOrders();
      state = state.copyWith(
        status: OrderStatus.loaded,
        orders: orders,
      );
    } catch (e) {
      state = state.copyWith(
        status: OrderStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshOrders() async {
    try {
      final orders = await _repository.getOrders();
      state = state.copyWith(
        status: OrderStatus.loaded,
        orders: orders,
      );
    } catch (e) {
      state = state.copyWith(
        status: OrderStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      await _repository.cancelOrder(orderId);
      final updatedOrders = state.orders.where((o) => o.id != orderId).toList();
      state = state.copyWith(orders: updatedOrders);
      return true;
    } catch (e) {
      return false;
    }
  }
}
