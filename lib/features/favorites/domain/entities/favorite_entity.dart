class FavoriteEntity {
  final String id;
  final String plantId; 
  final String name;
  final String category;
  final String description;
  final double price;
  final List<String> plantImages;
  final DateTime? createdAt;
  final int stock;

  FavoriteEntity({
    required this.id,
    required this.plantId, 
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.plantImages,
    this.createdAt,
    required this.stock,
  });
}
