import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nurser_e/features/favorites/domain/entities/favorite_entity.dart';
import 'package:nurser_e/features/plants/data/models/plant_api_model.dart';

part 'favorite_api_model.g.dart';

@JsonSerializable()
class FavoriteApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? userId;
  final List<PlantApiModel> plants;

  FavoriteApiModel({this.id, this.userId, required this.plants});
  factory FavoriteApiModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteApiModelToJson(this);

  List<FavoriteEntity> toEntityList() {
    return plants
        .map(
          (plant) => FavoriteEntity(
            id: plant.id ?? '',
            plantId: plant.id ?? '',
            name: plant.name,
            category: plant.category,
            description: plant.description,
            price: plant.price,
            plantImages: plant.plantImages,
            stock: plant.stock,
          ),
        )
        .toList();
  }

  
}
