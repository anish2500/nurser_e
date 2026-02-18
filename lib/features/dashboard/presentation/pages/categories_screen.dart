import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/app/theme/theme_colors_extension.dart';
import 'package:nurser_e/core/api/api_endpoints.dart';
import 'package:nurser_e/core/widgets/product_card.dart';
import 'package:nurser_e/features/plants/data/repositories/plant_repository.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';
import 'package:nurser_e/features/view_plant/presentation/pages/view_plant_screen.dart';

final indoorPlantsProvider = FutureProvider.autoDispose<List<PlantEntity>>((
  ref,
) async {
  final repository = ref.read(
    plantRepositoryProvider,
  ); // <-- Use repository instead
  return await repository.getAllPlants(category: 'INDOOR');
});
final outdoorPlantsProvider = FutureProvider.autoDispose<List<PlantEntity>>((
  ref,
) async {
  final repository = ref.read(plantRepositoryProvider);
  return await repository.getAllPlants(category: 'OUTDOOR');
});
final floweringPlantsProvider = FutureProvider.autoDispose<List<PlantEntity>>((
  ref,
) async {
  final repository = ref.read(plantRepositoryProvider);
  return await repository.getAllPlants(category: 'FLOWERING');
});

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildCategorySection(
              context: context,
              title: 'Indoor',
              categoryProvider: indoorPlantsProvider,
            ),
            const SizedBox(height: 20),
            _buildCategorySection(
              context: context,
              title: 'Outdoor',
              categoryProvider: outdoorPlantsProvider,
            ),
            const SizedBox(height: 20),
            _buildCategorySection(
              context: context,
              title: 'Flowering',
              categoryProvider: floweringPlantsProvider,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection({
    required BuildContext context,
    required String title,
    required FutureProvider<List<PlantEntity>> categoryProvider,
  }) {
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
          child: Consumer(
            builder: (context, ref, child) {
              final plantsAsync = ref.watch(categoryProvider);

              return plantsAsync.when(
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
              );
            },
          ),
        ),
      ],
    );
  }
}
