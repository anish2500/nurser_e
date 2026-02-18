import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nurser_e/core/api/api_endpoints.dart';
import 'package:nurser_e/core/widgets/my_button.dart';
import 'package:nurser_e/core/widgets/product_card.dart';
import 'package:nurser_e/app/theme/theme_colors_extension.dart';
import 'package:nurser_e/features/plants/data/repositories/plant_repository.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';
import 'package:nurser_e/features/view_plant/presentation/pages/view_plant_screen.dart';
import 'package:nurser_e/app/theme/app_colors.dart';
import 'package:nurser_e/features/dashboard/presentation/pages/categories_screen.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final allPlantsProvider = FutureProvider<List<PlantEntity>>((ref) async {
  final repository = ref.read(plantRepositoryProvider);
  return await repository.getAllPlants();
});

final filteredPlantsProvider = Provider<AsyncValue<List<PlantEntity>>>((ref) {
  final plantsAsync = ref.watch(allPlantsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  return plantsAsync.whenData((plants) {
    if (query.isEmpty) return plants;
    return plants.where((plant) {
      return plant.name.toLowerCase().contains(query) ||
          plant.category.toLowerCase().contains(query);
    }).toList();
  });
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final List<Map<String, double>> circleImagePositions = [
    {'right': 50, 'top': 30, 'size': 40},
    {'right': 20, 'top': 70, 'size': 40},
    {'right': 80, 'bottom': 50, 'size': 40},
  ];

  final List<String> imagePaths = [
    'assets/images/plant1.jpg',
    'assets/images/plant2.jpg',
    'assets/images/plant3.jpg',
  ];

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToCategories() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CategoriesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plantsAsync = ref.watch(filteredPlantsProvider);
    final query = ref.watch(searchQueryProvider);

    return SizedBox.expand(
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Text(
                    "Dashboard",
                    style: TextStyle(
                      fontFamily: 'Poppins Bold',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Colors.green[400],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade600,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.grey.shade600,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  ref.read(searchQueryProvider.notifier).state =
                                      '';
                                  setState(() {});
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        ref.read(searchQueryProvider.notifier).state = value;
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 1,
                    color: const Color(0xFF3DC352),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 160,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "New Arrivals",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  "Explore the latest",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  "plant arrived in our garden",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                MyButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                             const CategoriesScreen(),
                                      ),
                                    );
                                  },
                                  text: "Shop Now",
                                  width: 120,
                                  height: 40,
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    70,
                                    192,
                                    84,
                                  ),
                                  textColor: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: circleImagePositions[0]['right'],
                            top: circleImagePositions[0]['top'],
                            child: Container(
                              width: circleImagePositions[0]['size'],
                              height: circleImagePositions[0]['size'],
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                image: DecorationImage(
                                  image: AssetImage(imagePaths[0]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: circleImagePositions[1]['right'],
                            top: circleImagePositions[1]['top'],
                            child: Container(
                              width: circleImagePositions[1]['size'],
                              height: circleImagePositions[1]['size'],
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                image: DecorationImage(
                                  image: AssetImage(imagePaths[1]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: circleImagePositions[2]['right'],
                            bottom: circleImagePositions[2]['bottom'],
                            child: Container(
                              width: circleImagePositions[2]['size'],
                              height: circleImagePositions[2]['size'],
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                image: DecorationImage(
                                  image: AssetImage(imagePaths[2]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          query.isNotEmpty ? 'Search Results' : 'All Plants',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: context.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        if (query.isEmpty)
                          TextButton(
                            onPressed: _navigateToCategories,
                            child: Text(
                              'View All',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // const SizedBox(height:6),
                  plantsAsync.when(
                    data: (plants) {
                      if (plants.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.eco,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No plants available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final displayPlants = query.isEmpty
                          ? plants.take(8).toList()
                          : plants;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: displayPlants.length,
                          itemBuilder: (context, index) {
                            final plant = displayPlants[index];
                            return ProductCard(
                              title: plant.name,
                              price: 'Rs ${plant.price.toStringAsFixed(2)}',
                              categories: plant.category,
                              imagePath: plant.plantImages.isNotEmpty
                                  ? '${ApiEndpoints.imageBaseUrl}/plant_images/${plant.plantImages.first}'
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
                              },
                            );
                          },
                        ),
                      );
                    },
                    loading: () => Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    error: (e, _) => Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: Text(
                          'Error loading plants',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
