import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/cart/data/repositories/cart_repository.dart';
import 'package:nurser_e/features/cart/domain/repositories/cart_repository.dart';

class ClearCartUsecaseParams extends Equatable {
  const ClearCartUsecaseParams();

  @override
  List<Object?> get props => [];
}

final clearCartUsecaseProvider = Provider<ClearCartUsecase>((ref) {
  return ClearCartUsecase(ref.read(cartRepositoryProvider));
});

class ClearCartUsecase implements UsecaseWithoutParams<void> {
  final CartRepository _repository;

  ClearCartUsecase(this._repository);

  @override
  Future<Either<Failure, void>> call() async {
    try {
      await _repository.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
