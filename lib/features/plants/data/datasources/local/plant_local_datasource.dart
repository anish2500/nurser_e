import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/services/hive/hive_service.dart';
import 'package:nurser_e/features/plants/data/models/plant_hive_model.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';

final plantLocalDatasourceProvider = Provider<PlantLocalDatasource>((ref) {
  return PlantLocalDatasourceImpl(ref.read(hiveServiceProvider));
});

abstract class PlantLocalDatasource {
  Future<List<PlantEntity>> getCachedPlants({String? category});
  Future<void> cachePlants(List<PlantEntity> plants);
  Future<PlantEntity?> getCachedPlantById(String id);
}

class PlantLocalDatasourceImpl implements PlantLocalDatasource {
  final HiveService hiveService;

  PlantLocalDatasourceImpl(this.hiveService);

  @override
  Future<void> cachePlants(List<PlantEntity> plants) async {
    final hiveModels = plants.map((e) => PlantHiveModel.fromEntity(e)).toList();
    await hiveService.cachePlants(hiveModels);
  }

  @override
  Future<List<PlantEntity>> getCachedPlants({String? category}) async {
    final cachedModels = hiveService.getCachePlants();
    final entities = PlantHiveModel.toEntityList(cachedModels);

    if (category != null) {
      return entities.where((plant) => plant.category == category).toList();
    }
    return entities;
  }

  @override
  Future<PlantEntity?> getCachedPlantById(String id) async {
    final cachedModels = hiveService.getCachePlants();
    final entities = PlantHiveModel.toEntityList(cachedModels);
    try {
      return entities.firstWhere((plant) => plant.id == id);
    } catch (e) {
      return null; 
    }
  }
}
