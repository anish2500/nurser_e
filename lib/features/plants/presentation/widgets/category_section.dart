import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/app/theme/theme_colors_extension.dart';
import 'package:nurser_e/core/api/api_endpoints.dart';
import 'package:nurser_e/core/widgets/product_card.dart';
import 'package:nurser_e/features/favorites/presentation/view_model/favorite_view_model.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';
import 'package:nurser_e/features/plants/presentation/pages/view_plant_screen.dart';

class CategorySection extends ConsumerWidget {
  final String title;
  final FutureProvider<List<PlantEntity>> categoryProvider;

  const CategorySection({
    super.key,
    required this.title,
    required this.categoryProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantsAsync = ref.watch(categoryProvider);
    final favoritesState = ref.watch(favoritesViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: TextStyle(
              color: context.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: plantsAsync.when(
            data: (plants) {
              if (plants.isEmpty) {
                return Center(
                  child: Text(
                    'No plants available',
                    style: TextStyle(color: context.textSecondary),
                  ),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  final plant = plants[index];
                  final isFavorite = favoritesState.favorites.any(
                    (fav) => fav.plantId == plant.id,
                  );
                  String getFullImageUrl(String? imagePath) {
                    if (imagePath == null || imagePath.isEmpty) return '';
                    if (imagePath.startsWith('http')) return imagePath;
                    return '${ApiEndpoints.imageBaseUrl}/plant_images/$imagePath';
                  }

                  return ProductCard(
                    title: plant.name,
                    price: 'Rs ${plant.price.toStringAsFixed(2)}',
                    categories: plant.category,
                    imagePath: plant.plantImages.isNotEmpty
                        ? getFullImageUrl(plant.plantImages.first)
                        : null,
                    isNetworkImage: true,
                    isFavorite: isFavorite,
                    onFavoriteToggle: () {
                      ref
                          .read(favoritesViewModelProvider.notifier)
                          .toggleFavorite(plant);
                      final isCurrentlyFavorite = favoritesState.favorites
                          .any((fav) => fav.plantId == plant.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isCurrentlyFavorite
                                ? '${plant.name} removed from favorites!'
                                : '${plant.name} added to favorites!',
                          ),
                          backgroundColor: isCurrentlyFavorite
                              ? Colors.red
                              : Colors.green,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ViewPlantScreen(plantId: plant.id),
                        ),
                      );
                      debugPrint('Tapped on ${plant.name}');
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => const Center(
              child: Text(
                'Error loading plants',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
