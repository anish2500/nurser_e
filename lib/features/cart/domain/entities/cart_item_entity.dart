//second step after creating endpoints is to create a structure that is entity
class CartItemEntity {
  final String id;
  final String plantId;
  final String plantName;
  final String plantImage;
  final double price;
  final int quantity; 

  CartItemEntity({
    required this.id, 
    required this.plantId, 
    required this.plantName, 
    required this.plantImage, 
    required this.price, 
    required this.quantity
  });
}
