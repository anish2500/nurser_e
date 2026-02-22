import 'package:dartz/dartz.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/features/payment/domain/entities/payment_entity.dart';

abstract interface class IPaymentRepository {
  Future<Either<Failure, PaymentEntity>> createPayment({
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String paymentMethod,
    String? transactionId,
  });

  Future<Either<Failure, PaymentEntity>> getPaymentStatus(String orderId);

  Future<Either<Failure, PaymentEntity>> updatePaymentStatus({
    required String orderId,
    required String status,
    String? transactionId,
  });
}
