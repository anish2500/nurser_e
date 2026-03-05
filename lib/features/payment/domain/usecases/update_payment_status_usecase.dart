import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/payment/data/repositories/payment_repository.dart';
import 'package:nurser_e/features/payment/domain/entities/payment_entity.dart';
import 'package:nurser_e/features/payment/domain/repositories/payment_repository.dart';

class UpdatePaymentStatusUsecaseParams extends Equatable {
  final String orderId;
  final String status;
  final String? transactionId;

  const UpdatePaymentStatusUsecaseParams({
    required this.orderId,
    required this.status,
    this.transactionId,
  });

  @override
  List<Object?> get props => [orderId, status, transactionId];
}

final updatePaymentStatusUsecaseProvider = Provider<UpdatePaymentStatusUsecase>((ref) {
  return UpdatePaymentStatusUsecase(ref.read(paymentRepositoryProvider));
});

class UpdatePaymentStatusUsecase implements UsecaseWithParams<PaymentEntity, UpdatePaymentStatusUsecaseParams> {
  final IPaymentRepository _repository;

  UpdatePaymentStatusUsecase(this._repository);

  @override
  Future<Either<Failure, PaymentEntity>> call(UpdatePaymentStatusUsecaseParams params) async {
    return await _repository.updatePaymentStatus(
      orderId: params.orderId,
      status: params.status,
      transactionId: params.transactionId,
    );
  }
}
