import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/favorites/data/repositories/favorite_repository.dart';
import 'package:nurser_e/features/favorites/domain/entities/favorite_entity.dart';
import 'package:nurser_e/features/favorites/domain/repositories/favorite_repository.dart';

class GetFavoritesUsecaseParams extends Equatable {
  const GetFavoritesUsecaseParams();

  @override
  List<Object?> get props => [];
}

final getFavoritesUsecaseProvider = Provider<GetFavoritesUsecase>((ref) {
  return GetFavoritesUsecase(ref.read(favoritesRepositoryProvider));
});

class GetFavoritesUsecase implements UsecaseWithoutParams<List<FavoriteEntity>> {
  final FavoriteRepository _repository;

  GetFavoritesUsecase(this._repository);

  @override
  Future<Either<Failure, List<FavoriteEntity>>> call() async {
    try {
      final result = await _repository.getFavorites();
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
