import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/plants/data/repositories/plant_repository.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';
import 'package:nurser_e/features/plants/domain/repositories/plant_repository.dart';

class GetAllPlantsUsecaseParams extends Equatable {
  final String? category;

  const GetAllPlantsUsecaseParams({this.category});

  @override
  List<Object?> get props => [category];
}

final getAllPlantsUsecaseProvider = Provider<GetAllPlantsUsecase>((ref) {
  return GetAllPlantsUsecase(ref.read(plantRepositoryProvider));
});

class GetAllPlantsUsecase implements UsecaseWithParams<List<PlantEntity>, GetAllPlantsUsecaseParams> {
  final PlantRepository _repository;

  GetAllPlantsUsecase(this._repository);

  @override
  Future<Either<Failure, List<PlantEntity>>> call(GetAllPlantsUsecaseParams params) async {
    try {
      final result = await _repository.getAllPlants(category: params.category);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
