import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/cart/data/repositories/cart_repository.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';
import 'package:nurser_e/features/cart/domain/repositories/cart_repository.dart';

class GetCartUsecaseParams extends Equatable {
  const GetCartUsecaseParams();

  @override
  List<Object?> get props => [];
}

final getCartUsecaseProvider = Provider<GetCartUsecase>((ref) {
  return GetCartUsecase(ref.read(cartRepositoryProvider));
});

class GetCartUsecase implements UsecaseWithoutParams<List<CartItemEntity>> {
  final CartRepository _repository;

  GetCartUsecase(this._repository);

  @override
  Future<Either<Failure, List<CartItemEntity>>> call() async {
    try {
      final result = await _repository.getCart();
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
