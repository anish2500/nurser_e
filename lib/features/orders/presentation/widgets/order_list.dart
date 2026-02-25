import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/features/orders/presentation/state/order_state.dart';
import 'package:nurser_e/features/orders/presentation/view_model/order_view_model.dart';
import 'package:nurser_e/features/orders/presentation/widgets/order_card.dart';

class OrderList extends ConsumerWidget {
  final OrderState orderState;
  final String Function(DateTime?) formatDate;
  final Function(String orderId)? onCancelOrder;

  const OrderList({
    super.key,
    required this.orderState,
    required this.formatDate,
    this.onCancelOrder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(orderViewModelProvider.notifier).refreshOrders();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orderState.orders.length,
        itemBuilder: (context, index) {
          final order = orderState.orders[index];
          return OrderCard(
            order: order,
            formatDate: formatDate,
            onCancel: onCancelOrder != null 
                ? () => onCancelOrder!(order.id)
                : null,
          );
        },
      ),
    );
  }
}
