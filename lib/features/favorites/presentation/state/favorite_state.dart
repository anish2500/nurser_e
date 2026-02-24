import 'package:equatable/equatable.dart';
import 'package:nurser_e/features/favorites/domain/entities/favorite_entity.dart';

enum FavoriteStatus { initial, loading, loaded, error }

class FavoriteState extends Equatable {
  final FavoriteStatus status;
  final List<FavoriteEntity> favorites;
  final String? errorMessage;

  const FavoriteState({
    required this.status,
    required this.favorites,
    this.errorMessage,
  });

  factory FavoriteState.initial() {
    return const FavoriteState(
      status: FavoriteStatus.initial,
      favorites: [],
      errorMessage: null,
    );
  }

  FavoriteState copyWith({
    FavoriteStatus? status,
    List<FavoriteEntity>? favorites,
    String? errorMessage,
  }) {
    return FavoriteState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      errorMessage: errorMessage,
    );
  }

  @override
 
  List<Object?> get props => [status, favorites, errorMessage];
}
