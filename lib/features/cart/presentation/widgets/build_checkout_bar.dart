
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/app/theme/app_colors.dart';
import 'package:nurser_e/core/services/connectivity/network_info.dart';
import 'package:nurser_e/features/cart/presentation/state/cart_state.dart';
import 'package:nurser_e/features/payment/presentation/pages/payment_screen.dart';

class BuildCheckoutBar extends StatelessWidget {
  const BuildCheckoutBar({
    super.key,
    required this.ref,
    required this.context,
    required this.cartState,
  });

  final WidgetRef ref;
  final BuildContext context;
  final CartState cartState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurface
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total (${cartState.totalItems} items)',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                Text(
                  'Rs ${cartState.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                final networkInfo = ref.read(networkInfoProvider);
                final messenger = ScaffoldMessenger.of(context);

                final isOnline = await networkInfo.isConnected;

                if (!isOnline) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('No Internet Connection'),
                      content: const Text(
                        'Please go online to proceed with checkout.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }
                
                if (cartState.items.isEmpty) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: const Text('Your cart is empty'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
