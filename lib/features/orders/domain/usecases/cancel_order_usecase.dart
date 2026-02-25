import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/orders/data/repositories/order_repository.dart';
import 'package:nurser_e/features/orders/domain/entities/order_entity.dart';
import 'package:nurser_e/features/orders/domain/repositories/order_repository.dart';

class CancelOrderUsecaseParams extends Equatable {
  final String orderId;

  const CancelOrderUsecaseParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

final cancelOrderUsecaseProvider = Provider<CancelOrderUsecase>((ref) {
  return CancelOrderUsecase(ref.read(orderRepositoryProvider));
});

class CancelOrderUsecase implements UsecaseWithParams<OrderEntity, CancelOrderUsecaseParams> {
  final OrderRepository _repository;

  CancelOrderUsecase(this._repository);

  @override
  Future<Either<Failure, OrderEntity>> call(CancelOrderUsecaseParams params) async {
    try {
      final result = await _repository.cancelOrder(params.orderId);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
