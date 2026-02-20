//after cart repsoitory implementation define a cart_state here 
import 'package:equatable/equatable.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';

enum CartStatus { initial, loading, loaded, error }

class CartState extends Equatable {
  final CartStatus status;
  final List<CartItemEntity> items;
  final String? errorMessage;

  const CartState({
    required this.status,
    required this.items,
    this.errorMessage,
  });

  factory CartState.initial() {
    return const CartState(
      status: CartStatus.initial,
      items:[],
      errorMessage: null,
    );
  }

  double get totalAmount {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  CartState copyWith({
    CartStatus? status,
    List<CartItemEntity>? items,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}
