class PlantEntity {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final List<String> plantImages;
  final DateTime? createdAt; 

  PlantEntity({
    required this.id, 
    required this.name, 
    required this.description, 
    required this.category, 
    required this.price, 
    required this.plantImages, 
    this.createdAt, 

  });
}
