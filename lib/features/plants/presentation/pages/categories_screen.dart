import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/app/theme/theme_colors_extension.dart';
import 'package:nurser_e/features/plants/data/repositories/plant_repository.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';
import 'package:nurser_e/features/plants/presentation/widgets/category_section.dart';

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
            CategorySection(
              title: 'Indoor',
              categoryProvider: indoorPlantsProvider,
            ),
            const SizedBox(height: 20),
            CategorySection(
              title: 'Outdoor',
              categoryProvider: outdoorPlantsProvider,
            ),
            const SizedBox(height: 20),
            CategorySection(
              title: 'Flowering',
              categoryProvider: floweringPlantsProvider,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
