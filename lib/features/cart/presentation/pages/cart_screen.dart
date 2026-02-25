import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nurser_e/app/theme/theme_colors_extension.dart';
import 'package:nurser_e/core/api/api_endpoints.dart';
import 'package:nurser_e/features/cart/presentation/state/cart_state.dart';
import 'package:nurser_e/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:nurser_e/app/theme/app_colors.dart';
import 'package:nurser_e/features/cart/presentation/widgets/build_checkout_bar.dart';
import 'package:nurser_e/features/cart/presentation/widgets/build_empty_cart.dart';


class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});
  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(cartViewModelProvider.notifier).loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use ref.watch to rebuild when state changes
    final cartState = ref.watch(cartViewModelProvider);
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        title: Text(
          'My Cart',
          style: TextStyle(
            color: context.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        actions: [
          if (cartState.items.isNotEmpty)
            IconButton(
              icon: Icon(Icons.refresh, color: context.textPrimary),
              onPressed: () {
                ref.read(cartViewModelProvider.notifier).loadCart();
              },
            ),
        ],
      ),
      body: _buildBody(cartState),
      bottomNavigationBar: cartState.items.isNotEmpty
          ? BuildCheckoutBar(ref: ref, context: context, cartState: cartState)
          : null,
    );
  }

  Widget _buildBody(CartState cartState) {
    if (cartState.status == CartStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (cartState.status == CartStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              cartState.errorMessage ?? 'Error loading cart',
              style: TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(cartViewModelProvider.notifier).loadCart();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (cartState.items.isEmpty) {
      return BuildEmptyCart(context: context);
    }
    return _buildCartList(context, cartState);
  }

  Widget _buildCartList(BuildContext context, CartState cartState) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cartState.items.length,
      itemBuilder: (context, index) {
        final item = cartState.items[index];
        return _buildCartItem(context, item);
      },
    );
  }

  Widget _buildCartItem(BuildContext context, dynamic item) {
    String fullImageUrl = '';
    if (item.plantImage != null && item.plantImage.isNotEmpty) {
      fullImageUrl = item.plantImage.startsWith('http')
          ? item.plantImage
          : '${ApiEndpoints.imageBaseUrl}/plant_images/${item.plantImage}';
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: fullImageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: fullImageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, color: Colors.grey[600]),
                    ),
                    errorWidget: (context, url, error) =>
                        _buildPlaceholderImage(),
                  )
                : _buildPlaceholderImage(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.plantName ?? 'Unknown Plant',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs ${(item.price ?? 0).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  if (item.quantity > 1) {
                    ref
                        .read(cartViewModelProvider.notifier)
                        .updateQuantity(item.plantId, item.quantity - 1);
                  }
                },
              ),
              Text(
                '${item.quantity}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  ref
                      .read(cartViewModelProvider.notifier)
                      .updateQuantity(item.plantId, item.quantity + 1);
                },
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () {
              ref
                  .read(cartViewModelProvider.notifier)
                  .removeFromCart(item.plantId);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 70,
      height: 70,
      color: AppColors.surfaceVariant,
      child: const Icon(Icons.local_florist, color: AppColors.primary),
    );
  }
}
