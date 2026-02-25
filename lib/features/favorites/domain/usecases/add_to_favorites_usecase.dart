import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/favorites/data/repositories/favorite_repository.dart';
import 'package:nurser_e/features/favorites/domain/entities/favorite_entity.dart';
import 'package:nurser_e/features/favorites/domain/repositories/favorite_repository.dart';

class AddToFavoritesUsecaseParams extends Equatable {
  final String plantId;

  const AddToFavoritesUsecaseParams({required this.plantId});

  @override
  List<Object?> get props => [plantId];
}

final addToFavoritesUsecaseProvider = Provider<AddToFavoritesUsecase>((ref) {
  return AddToFavoritesUsecase(ref.read(favoritesRepositoryProvider));
});

class AddToFavoritesUsecase implements UsecaseWithParams<List<FavoriteEntity>, AddToFavoritesUsecaseParams> {
  final FavoriteRepository _repository;

  AddToFavoritesUsecase(this._repository);

  @override
  Future<Either<Failure, List<FavoriteEntity>>> call(AddToFavoritesUsecaseParams params) async {
    try {
      final result = await _repository.addToFavorites(params.plantId);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
