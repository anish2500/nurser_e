import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/favorites/data/repositories/favorite_repository.dart';
import 'package:nurser_e/features/favorites/domain/repositories/favorite_repository.dart';

class CheckIsFavoriteUsecaseParams extends Equatable {
  final String plantId;

  const CheckIsFavoriteUsecaseParams({required this.plantId});

  @override
  List<Object?> get props => [plantId];
}

final checkIsFavoriteUsecaseProvider = Provider<CheckIsFavoriteUsecase>((ref) {
  return CheckIsFavoriteUsecase(ref.read(favoritesRepositoryProvider));
});

class CheckIsFavoriteUsecase implements UsecaseWithParams<bool, CheckIsFavoriteUsecaseParams> {
  final FavoriteRepository _repository;

  CheckIsFavoriteUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call(CheckIsFavoriteUsecaseParams params) async {
    try {
      final result = await _repository.checkIsFavorite(params.plantId);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
