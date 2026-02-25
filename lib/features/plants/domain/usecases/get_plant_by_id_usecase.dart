import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/plants/data/repositories/plant_repository.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';
import 'package:nurser_e/features/plants/domain/repositories/plant_repository.dart';

class GetPlantByIdUsecaseParams extends Equatable {
  final String id;

  const GetPlantByIdUsecaseParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final getPlantByIdUsecaseProvider = Provider<GetPlantByIdUsecase>((ref) {
  return GetPlantByIdUsecase(ref.read(plantRepositoryProvider));
});

class GetPlantByIdUsecase implements UsecaseWithParams<PlantEntity?, GetPlantByIdUsecaseParams> {
  final PlantRepository _repository;

  GetPlantByIdUsecase(this._repository);

  @override
  Future<Either<Failure, PlantEntity?>> call(GetPlantByIdUsecaseParams params) async {
    try {
      final result = await _repository.getPlantById(params.id);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
