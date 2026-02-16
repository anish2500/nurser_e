import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/features/plants/data/datasources/remote/plant_remote_datasource.dart';
import 'package:nurser_e/features/plants/data/models/plant_api_model.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';
import 'package:nurser_e/features/plants/domain/plant_repository.dart';

final plantRepositoryProvider = Provider<PlantRepository>((ref) {
  return PlantRepositoryImpl(
    remoteDatasource: ref.read(plantRemoteDatasourceProvider),
  );
});

class PlantRepositoryImpl implements PlantRepository {
  final PlantRemoteDatasource remoteDatasource;

  PlantRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<PlantEntity>> getAllPlants({String? category}) async {
    final models = await remoteDatasource.getAllPlants(category: category);
    return PlantApiModel.toEntityList(models);
  }

  @override
  Future<PlantEntity?> getPlantById(String id) async {
    final model = await remoteDatasource.getPlantById(id);
    return model?.toEntity();
  }
}
