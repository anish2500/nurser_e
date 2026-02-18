import 'package:hive/hive.dart';
import 'package:nurser_e/core/constants/hive_table_constant.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';
import 'package:uuid/uuid.dart';

part 'plant_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.plantTypeId)
class PlantHiveModel extends HiveObject {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String category;
  @HiveField(4)
  final double price;
  @HiveField(5)
  final List<String> plantImages;
  @HiveField(6)
  final DateTime? createdAt;
  @HiveField(7)
  final int stock; 

  PlantHiveModel({
    String? id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.plantImages,
    this.createdAt,
    required this.stock, 
  }) : id = id ?? const Uuid().v4();

  //from Entity
  factory PlantHiveModel.fromEntity(PlantEntity entity) {
    return PlantHiveModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      category: entity.category,
      price: entity.price,
      plantImages: entity.plantImages,
      createdAt: entity.createdAt,
      stock: entity.stock, 
    );
  }

  //to entity
  PlantEntity toEntity() {
    return PlantEntity(
      id: id ?? '',
      name: name,
      description: description,
      category: category,
      price: price,
      plantImages: plantImages,
      createdAt: createdAt,
      stock: stock, 
    );
  }

  static List<PlantEntity> toEntityList(List<PlantHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
