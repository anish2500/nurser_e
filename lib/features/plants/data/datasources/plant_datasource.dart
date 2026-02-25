import 'package:nurser_e/features/plants/data/models/plant_api_model.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';

abstract interface class IPlantLocalDataSource {
  Future<List<PlantEntity>> getCachedPlants({String? category});
  Future<void> cachePlants(List<PlantEntity> plants);
  Future<PlantEntity?> getCachedPlantById(String id);
}

abstract interface class IPlantRemoteDataSource {
  Future<List<PlantApiModel>> getAllPlants({String? category});
  Future<PlantApiModel?> getPlantById(String id);
}
