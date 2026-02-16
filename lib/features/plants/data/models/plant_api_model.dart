import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';
part 'plant_api_model.g.dart';
@JsonSerializable()
class PlantApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String description;
  final String category;
  final double price;
  @JsonKey(name: 'plantImage')
  final List<String> plantImages;
  final DateTime? createdAt;
  PlantApiModel({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.plantImages,
    this.createdAt,
  });
  factory PlantApiModel.fromJson(Map<String, dynamic> json) =>
      _$PlantApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlantApiModelToJson(this);
  PlantEntity toEntity() {
    return PlantEntity(
      id: id ?? '',
      name: name,
      description: description,
      category: category,
      price: price.toDouble(),
      plantImages: plantImages,
      createdAt: createdAt,
    );
  }
  static List<PlantEntity> toEntityList(List<PlantApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}