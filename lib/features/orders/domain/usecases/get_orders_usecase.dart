import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/orders/data/repositories/order_repository.dart';
import 'package:nurser_e/features/orders/domain/entities/order_entity.dart';
import 'package:nurser_e/features/orders/domain/repositories/order_repository.dart';

class GetOrdersUsecaseParams extends Equatable {
  const GetOrdersUsecaseParams();

  @override
  List<Object?> get props => [];
}

final getOrdersUsecaseProvider = Provider<GetOrdersUsecase>((ref) {
  return GetOrdersUsecase(ref.read(orderRepositoryProvider));
});

class GetOrdersUsecase implements UsecaseWithoutParams<List<OrderEntity>> {
  final OrderRepository _repository;

  GetOrdersUsecase(this._repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call() async {
    try {
      final result = await _repository.getOrders();
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
