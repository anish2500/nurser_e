import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';

abstract class PlantRepository {
  Future<List<PlantEntity>> getAllPlants({String? category});
  Future<PlantEntity?> getPlantById(String id);
}
