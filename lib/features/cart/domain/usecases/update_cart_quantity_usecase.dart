import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/cart/data/repositories/cart_repository.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';
import 'package:nurser_e/features/cart/domain/repositories/cart_repository.dart';

class UpdateCartQuantityUsecaseParams extends Equatable {
  final String plantId;
  final int quantity;

  const UpdateCartQuantityUsecaseParams({
    required this.plantId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [plantId, quantity];
}

final updateCartQuantityUsecaseProvider = Provider<UpdateCartQuantityUsecase>((ref) {
  return UpdateCartQuantityUsecase(ref.read(cartRepositoryProvider));
});

class UpdateCartQuantityUsecase implements UsecaseWithParams<CartItemEntity, UpdateCartQuantityUsecaseParams> {
  final CartRepository _repository;

  UpdateCartQuantityUsecase(this._repository);

  @override
  Future<Either<Failure, CartItemEntity>> call(UpdateCartQuantityUsecaseParams params) async {
    try {
      final result = await _repository.updateQuantity(params.plantId, params.quantity);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
