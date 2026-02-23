class OrderEntity {
  final String id;
  final String userId;
  final List<OrderItemEntity> items;
  final double totalAmount;
  final String paymentMethod;
  final String orderStatus;
  final String paymentStatus;
  final String? transactionId;
  final DateTime? createdAt;

  OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.orderStatus,
    required this.paymentStatus,
    this.transactionId,
    this.createdAt,
  });
}

class OrderItemEntity {
  final String id;
  final String plantId;
  final String plantName;
  final String plantImage;
  final double price;
  final int quantity;

  OrderItemEntity({
    required this.id,
    required this.plantId,
    required this.plantName,
    required this.plantImage,
    required this.price,
    required this.quantity,
  });
}
