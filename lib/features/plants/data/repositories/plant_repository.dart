import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/services/hive/hive_service.dart';
import 'package:nurser_e/features/plants/data/datasources/local/plant_local_datasource.dart';
import 'package:nurser_e/features/plants/data/datasources/remote/plant_remote_datasource.dart';
import 'package:nurser_e/features/plants/data/models/plant_api_model.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';
import 'package:nurser_e/features/plants/domain/plant_repository.dart';

final plantRepositoryProvider = Provider<PlantRepository>((ref) {
  return PlantRepositoryImpl(
    remoteDatasource: ref.read(plantRemoteDatasourceProvider),
    localDatasource: ref.read(plantLocalDatasourceProvider),
    hiveService: ref.read(hiveServiceProvider),
  );
});

class PlantRepositoryImpl implements PlantRepository {
  final PlantRemoteDatasource remoteDatasource;
  final PlantLocalDatasource localDatasource;
  final HiveService hiveService;

  PlantRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.hiveService,
  });

  @override
  Future<List<PlantEntity>> getAllPlants({String? category}) async {
    try {
      final models = await remoteDatasource.getAllPlants(category: category);
      final entities = PlantApiModel.toEntityList(models);

      await localDatasource.cachePlants(entities);

      return entities;
    } catch (e) {
      return await localDatasource.getCachedPlants(category: category);
    }
  }

  @override
  Future<PlantEntity?> getPlantById(String id) async {
    try {
      final model = await remoteDatasource.getPlantById(id);
      return model?.toEntity();
    } catch (e) {
      return null;
    }
  }
}
