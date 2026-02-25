import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/favorites/data/repositories/favorite_repository.dart';
import 'package:nurser_e/features/favorites/domain/entities/favorite_entity.dart';
import 'package:nurser_e/features/favorites/domain/repositories/favorite_repository.dart';

class RemoveFromFavoritesUsecaseParams extends Equatable {
  final String plantId;

  const RemoveFromFavoritesUsecaseParams({required this.plantId});

  @override
  List<Object?> get props => [plantId];
}

final removeFromFavoritesUsecaseProvider = Provider<RemoveFromFavoritesUsecase>((ref) {
  return RemoveFromFavoritesUsecase(ref.read(favoritesRepositoryProvider));
});

class RemoveFromFavoritesUsecase implements UsecaseWithParams<List<FavoriteEntity>, RemoveFromFavoritesUsecaseParams> {
  final FavoriteRepository _repository;

  RemoveFromFavoritesUsecase(this._repository);

  @override
  Future<Either<Failure, List<FavoriteEntity>>> call(RemoveFromFavoritesUsecaseParams params) async {
    try {
      final result = await _repository.removeFromFavorites(params.plantId);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
