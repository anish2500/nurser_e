import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nurser_e/app/theme/app_colors.dart';
import 'package:nurser_e/core/api/api_endpoints.dart';
import 'package:nurser_e/features/orders/domain/entities/order_entity.dart';
import 'package:nurser_e/features/orders/presentation/widgets/order_status_chip.dart';
import 'package:nurser_e/features/orders/presentation/widgets/order_placeholder_image.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final String Function(DateTime?) formatDate;
  final VoidCallback? onCancel;

  const OrderCard({
    super.key,
    required this.order,
    required this.formatDate,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final canCancel = order.orderStatus != 'cancelled' && 
                      order.orderStatus != 'delivered';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurface
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.id.substring(0, 8)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              OrderStatusChip(status: order.orderStatus),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formatDate(order.createdAt),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const Divider(height: 24),
          ...order.items.map((item) => OrderItemWidget(item: item)),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment: ${order.paymentMethod == 'cash_on_delivery' ? 'Cash on Delivery' : 'Online'}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              Text(
                'Total: Rs ${order.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          if (canCancel && onCancel != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Cancel Order'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  final OrderItemEntity item;

  const OrderItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    String fullImageUrl = '';
    final imagePath = item.plantImage;
    if (imagePath.isNotEmpty) {
      fullImageUrl = imagePath.startsWith('http')
          ? imagePath
          : '${ApiEndpoints.imageBaseUrl}/plant_images/$imagePath';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: fullImageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: fullImageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                    errorWidget: (context, url, error) =>
                        const OrderPlaceholderImage(),
                  )
                : const OrderPlaceholderImage(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.plantName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Qty: ${item.quantity} × Rs ${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Rs ${(item.price * item.quantity).toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
