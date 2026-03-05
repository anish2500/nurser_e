import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/payment/data/repositories/payment_repository.dart';
import 'package:nurser_e/features/payment/domain/entities/payment_entity.dart';
import 'package:nurser_e/features/payment/domain/repositories/payment_repository.dart';

class GetPaymentStatusUsecaseParams extends Equatable {
  final String orderId;

  const GetPaymentStatusUsecaseParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

final getPaymentStatusUsecaseProvider = Provider<GetPaymentStatusUsecase>((ref) {
  return GetPaymentStatusUsecase(ref.read(paymentRepositoryProvider));
});

class GetPaymentStatusUsecase implements UsecaseWithParams<PaymentEntity, GetPaymentStatusUsecaseParams> {
  final IPaymentRepository _repository;

  GetPaymentStatusUsecase(this._repository);

  @override
  Future<Either<Failure, PaymentEntity>> call(GetPaymentStatusUsecaseParams params) async {
    return await _repository.getPaymentStatus(params.orderId);
  }
}
