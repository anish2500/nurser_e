import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/orders/data/repositories/order_repository.dart';
import 'package:nurser_e/features/orders/domain/entities/order_entity.dart';
import 'package:nurser_e/features/orders/domain/repositories/order_repository.dart';

class GetOrderByIdUsecaseParams extends Equatable {
  final String orderId;

  const GetOrderByIdUsecaseParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

final getOrderByIdUsecaseProvider = Provider<GetOrderByIdUsecase>((ref) {
  return GetOrderByIdUsecase(ref.read(orderRepositoryProvider));
});

class GetOrderByIdUsecase implements UsecaseWithParams<OrderEntity, GetOrderByIdUsecaseParams> {
  final OrderRepository _repository;

  GetOrderByIdUsecase(this._repository);

  @override
  Future<Either<Failure, OrderEntity>> call(GetOrderByIdUsecaseParams params) async {
    try {
      final result = await _repository.getOrderById(params.orderId);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
