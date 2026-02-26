import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/app/theme/app_colors.dart';
import 'package:nurser_e/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:nurser_e/features/payment/presentation/state/payment_state.dart';
import 'package:nurser_e/features/payment/presentation/view_model/payment_view_model.dart';
import 'package:nurser_e/features/payment/presentation/widgets/order_summary_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String selectedPaymentMethod = 'cash_on_delivery';
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartState = ref.read(cartViewModelProvider);
      ref.read(paymentViewModelProvider.notifier).initPaymentData(
            cartState.items,
            cartState.totalAmount,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentViewModelProvider);
    final cartState = ref.watch(cartViewModelProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkBackground
          : AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Payment',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderSummaryWidget(context: context, totalAmount: cartState.totalAmount, totalItems: cartState.totalItems),
            const SizedBox(height: 24),
            _buildPaymentMethods(),
            const SizedBox(height: 24),
            if (paymentState.status == PaymentStatus.failure)
              _buildError(paymentState.errorMessage),
          ],
        ),
      ),
      bottomNavigationBar: _buildPayButton(cartState.totalAmount),
    );
  }

  Widget _buildPaymentMethods() {
    return Container(
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
          Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildPaymentOption(
            'cash_on_delivery',
            'Cash on Delivery',
            'Pay when you receive your order',
            Icons.money,
          ),
          const Divider(),
          _buildPaymentOption(
            'online',
            'Online Payment',
            'Pay now using card/UPI/bank',
            Icons.credit_card,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    String value,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = selectedPaymentMethod == value;
    return InkWell(
      onTap: () {
        setState(() {
          selectedPaymentMethod = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String? message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message ?? 'An error occurred',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton(double totalAmount) {
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
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isProcessing ? null : () => _processPayment(totalAmount),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Pay Rs ${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _openEsewaApp() async {
    final Uri esewaUri = Uri.parse('esewa://');

    try {
      if (await canLaunchUrl(esewaUri)) {
        await launchUrl(esewaUri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please install eSewa app or use web version')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening eSewa: $e')),
        );
      }
    }
  }

  Future<void> _processOrderSuccess(double totalAmount) async {
    try {
      final success = await ref.read(paymentViewModelProvider.notifier).processPayment(
            paymentMethod: selectedPaymentMethod,
          );

      if (success && mounted) {
        try {
          await ref.read(cartViewModelProvider.notifier).clearCart();
        } catch (e) {
          // Ignore - cart might already be cleared by backend
        }
        ref.read(paymentViewModelProvider.notifier).reset();

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 28),
                SizedBox(width: 8),
                Text('Order Placed!'),
              ],
            ),
            content: Text(
              selectedPaymentMethod == 'cash_on_delivery'
                  ? 'Your order has been placed successfully. You will pay Rs ${totalAmount.toStringAsFixed(2)} on delivery.'
                  : 'Your payment was successful. Your order has been placed.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing order: $e')),
        );
      }
    }
  }

  Future<void> _processPayment(double totalAmount) async {
    if (selectedPaymentMethod == 'online') {
      // Try to open eSewa first
      final Uri esewaUri = Uri.parse('esewa://');
      bool esewaOpened = false;
      
      try {
        if (await canLaunchUrl(esewaUri)) {
          esewaOpened = await launchUrl(esewaUri, mode: LaunchMode.externalApplication);
        }
      } catch (e) {
        // Ignore errors, try fallback
      }
      
      // If eSewa app didn't open, try web version as fallback
      if (!esewaOpened) {
        final Uri esewaWeb = Uri.parse('https://esewa.com.np');
        try {
          await launchUrl(esewaWeb, mode: LaunchMode.externalApplication);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not open eSewa. Please install eSewa app.')),
            );
            return;
          }
        }
      }
      
      // Only show confirmation dialog after user returns
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('eSewa Payment'),
            content: const Text('Please complete payment in eSewa app and return here.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _processOrderSuccess(totalAmount);
                },
                child: const Text('I Completed Payment'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      }
      return;
    }
    // Cash on delivery logic...
    setState(() {
      isProcessing = true;
    });
    await _processOrderSuccess(totalAmount);
    if (mounted) {
      setState(() {
        isProcessing = false;
      });
    }
  }
}
