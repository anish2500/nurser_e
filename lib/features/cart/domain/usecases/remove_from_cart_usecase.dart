import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/cart/data/repositories/cart_repository.dart';
import 'package:nurser_e/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCartUsecaseParams extends Equatable {
  final String plantId;

  const RemoveFromCartUsecaseParams({required this.plantId});

  @override
  List<Object?> get props => [plantId];
}

final removeFromCartUsecaseProvider = Provider<RemoveFromCartUsecase>((ref) {
  return RemoveFromCartUsecase(ref.read(cartRepositoryProvider));
});

class RemoveFromCartUsecase implements UsecaseWithParams<void, RemoveFromCartUsecaseParams> {
  final CartRepository _repository;

  RemoveFromCartUsecase(this._repository);

  @override
  Future<Either<Failure, void>> call(RemoveFromCartUsecaseParams params) async {
    try {
      await _repository.removeFromCart(params.plantId);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
