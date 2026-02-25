import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/cart/data/repositories/cart_repository.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';
import 'package:nurser_e/features/cart/domain/repositories/cart_repository.dart';

class CheckoutUsecaseParams extends Equatable {
  final List<CartItemEntity> items;
  final double totalAmount;

  const CheckoutUsecaseParams({
    required this.items,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [items, totalAmount];
}

final checkoutUsecaseProvider = Provider<CheckoutUsecase>((ref) {
  return CheckoutUsecase(ref.read(cartRepositoryProvider));
});

class CheckoutUsecase implements UsecaseWithParams<Map<String, dynamic>, CheckoutUsecaseParams> {
  final CartRepository _repository;

  CheckoutUsecase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(CheckoutUsecaseParams params) async {
    try {
      final result = await _repository.checkout(
        items: params.items,
        totalAmount: params.totalAmount,
      );
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
