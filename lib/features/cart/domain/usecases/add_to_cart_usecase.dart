import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/cart/data/repositories/cart_repository.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';
import 'package:nurser_e/features/cart/domain/repositories/cart_repository.dart';

class AddToCartUsecaseParams extends Equatable {
  final String plantId;
  final String plantName;
  final String plantImage;
  final double price;
  final int quantity;

  const AddToCartUsecaseParams({
    required this.plantId,
    required this.plantName,
    required this.plantImage,
    required this.price,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [plantId, plantName, plantImage, price, quantity];
}

final addToCartUsecaseProvider = Provider<AddToCartUsecase>((ref) {
  return AddToCartUsecase(ref.read(cartRepositoryProvider));
});

class AddToCartUsecase implements UsecaseWithParams<CartItemEntity, AddToCartUsecaseParams> {
  final CartRepository _repository;

  AddToCartUsecase(this._repository);

  @override
  Future<Either<Failure, CartItemEntity>> call(AddToCartUsecaseParams params) async {
    try {
      final entity = CartItemEntity(
        id: '',
        plantId: params.plantId,
        plantName: params.plantName,
        plantImage: params.plantImage,
        price: params.price,
        quantity: params.quantity,
      );
      final result = await _repository.addToCart(entity);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
