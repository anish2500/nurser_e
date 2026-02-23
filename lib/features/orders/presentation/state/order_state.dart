import 'package:equatable/equatable.dart';
import 'package:nurser_e/features/orders/domain/entities/order_entity.dart';

enum OrderStatus { initial, loading, loaded, error }

class OrderState extends Equatable {
  final OrderStatus status;
  final List<OrderEntity> orders;
  final String? errorMessage;

  const OrderState({
    required this.status,
    required this.orders,
    this.errorMessage,
  });

  factory OrderState.initial() {
    return const OrderState(
      status: OrderStatus.initial,
      orders: [],
      errorMessage: null,
    );
  }

  double get totalSpent {
    return orders.fold(0, (sum, order) => sum + order.totalAmount);
  }

  int get totalOrders {
    return orders.length;
  }

  OrderState copyWith({
    OrderStatus? status,
    List<OrderEntity>? orders,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, orders, errorMessage];
}
