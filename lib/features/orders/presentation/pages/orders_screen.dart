import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/app/theme/app_colors.dart';
import 'package:nurser_e/features/orders/presentation/state/order_state.dart';
import 'package:nurser_e/features/orders/presentation/view_model/order_view_model.dart';
import 'package:nurser_e/features/orders/presentation/widgets/order_empty_state.dart';
import 'package:nurser_e/features/orders/presentation/widgets/order_list.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(orderViewModelProvider.notifier).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(
            fontFamily: "Poppins Regular",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (orderState.orders.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.read(orderViewModelProvider.notifier).loadOrders();
              },
            ),
        ],
      ),
      body: _buildBody(orderState),
    );
  }

  Widget _buildBody(OrderState orderState) {
    if (orderState.status == OrderStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (orderState.status == OrderStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              orderState.errorMessage ?? 'Error loading orders',
              style: const TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(orderViewModelProvider.notifier).loadOrders();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (orderState.orders.isEmpty) {
      return const OrderEmptyState();
    }

    return OrderList(
      orderState: orderState,
      formatDate: _formatDate,
      onCancelOrder: _handleCancelOrder,
    );
  }

  Future<void> _handleCancelOrder(String orderId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text(
          'Are you sure you want to cancel this order? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await ref
          .read(orderViewModelProvider.notifier)
          .cancelOrder(orderId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Order cancelled successfully'
                  : 'Failed to cancel order. Please try again.',
            ),
            backgroundColor: success ? AppColors.success : AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown date';
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
