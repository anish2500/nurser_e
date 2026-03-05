import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/payment/data/repositories/payment_repository.dart';
import 'package:nurser_e/features/payment/domain/entities/payment_entity.dart';
import 'package:nurser_e/features/payment/domain/repositories/payment_repository.dart';

class CreatePaymentUsecaseParams extends Equatable {
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String paymentMethod;
  final String? transactionId;

  const CreatePaymentUsecaseParams({
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    this.transactionId,
  });

  @override
  List<Object?> get props => [items, totalAmount, paymentMethod, transactionId];
}

final createPaymentUsecaseProvider = Provider<CreatePaymentUsecase>((ref) {
  return CreatePaymentUsecase(ref.read(paymentRepositoryProvider));
});

class CreatePaymentUsecase implements UsecaseWithParams<PaymentEntity, CreatePaymentUsecaseParams> {
  final IPaymentRepository _repository;

  CreatePaymentUsecase(this._repository);

  @override
  Future<Either<Failure, PaymentEntity>> call(CreatePaymentUsecaseParams params) async {
    return await _repository.createPayment(
      items: params.items,
      totalAmount: params.totalAmount,
      paymentMethod: params.paymentMethod,
      transactionId: params.transactionId,
    );
  }
}
