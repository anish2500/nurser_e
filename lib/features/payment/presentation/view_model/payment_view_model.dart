import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';
import 'package:nurser_e/features/payment/data/repositories/payment_repository.dart';
import 'package:nurser_e/features/payment/domain/repositories/payment_repository.dart';

import 'package:nurser_e/features/payment/presentation/state/payment_state.dart';

final paymentViewModelProvider = NotifierProvider<PaymentViewModel, PaymentState>(
  () => PaymentViewModel(),
);

class PaymentViewModel extends Notifier<PaymentState> {
  late final IPaymentRepository _repository;

  @override
  PaymentState build() {
    _repository = ref.read(paymentRepositoryProvider);
    return PaymentState.initial();
  }

  void initPaymentData(List<CartItemEntity> items, double totalAmount) {
    final itemsData = items
        .map((item) => {
              'plantId': item.plantId,
              'quantity': item.quantity,
              'price': item.price,
            })
        .toList();

    state = state.copyWith(
      cartItems: itemsData,
      totalAmount: totalAmount,
      status: PaymentStatus.initial,
    );
  }

  Future<bool> processPayment({
    required String paymentMethod,
    String? transactionId,
  }) async {
    state = state.copyWith(status: PaymentStatus.processing);

    final result = await _repository.createPayment(
      items: state.cartItems,
      totalAmount: state.totalAmount,
      paymentMethod: paymentMethod,
      transactionId: transactionId,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: PaymentStatus.failure,
          errorMessage: failure.message,
        );
        return false;
      },
      (payment) {
        state = state.copyWith(
          status: PaymentStatus.success,
          payment: payment,
        );
        return true;
      },
    );
  }

  Future<bool> updatePaymentStatus({
    required String orderId,
    required String status,
    String? transactionId,
  }) async {
    state = state.copyWith(status: PaymentStatus.processing);

    final result = await _repository.updatePaymentStatus(
      orderId: orderId,
      status: status,
      transactionId: transactionId,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: PaymentStatus.failure,
          errorMessage: failure.message,
        );
        return false;
      },
      (payment) {
        state = state.copyWith(
          status: PaymentStatus.success,
          payment: payment,
        );
        return true;
      },
    );
  }

  void reset() {
    state = PaymentState.initial();
  }
}
