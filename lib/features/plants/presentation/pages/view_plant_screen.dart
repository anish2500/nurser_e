import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nurser_e/core/api/api_endpoints.dart';
import 'package:nurser_e/core/services/connectivity/network_info.dart';
import 'package:nurser_e/core/widgets/my_button.dart';
import 'package:nurser_e/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:nurser_e/features/favorites/presentation/view_model/favorite_view_model.dart';
import 'package:nurser_e/features/plants/data/repositories/plant_repository.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';
import 'package:nurser_e/app/theme/app_colors.dart';

final plantDetailsProvider = FutureProvider.family<PlantEntity?, String>((
  ref,
  id,
) async {
  final repository = ref.read(plantRepositoryProvider);
  return await repository.getPlantById(id);
});

class ViewPlantScreen extends ConsumerStatefulWidget {
  final String plantId;
  const ViewPlantScreen({super.key, required this.plantId});
  @override
  ConsumerState<ViewPlantScreen> createState() => _ViewPlantScreenState();
}

class _ViewPlantScreenState extends ConsumerState<ViewPlantScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    if (imagePath.startsWith('http')) return imagePath;
    return '${ApiEndpoints.imageBaseUrl}/plant_images/$imagePath';
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plantAsync = ref.watch(plantDetailsProvider(widget.plantId));
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkBackground
          : AppColors.background,
      body: plantAsync.when(
        data: (plant) {
          if (plant == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.eco, size: 64, color: AppColors.textTertiary),
                  const SizedBox(height: 16),
                  Text(
                    'Plant not found',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }
          return _buildPlantDetails(context, plant);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                'Error loading plant',
                style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: plantAsync.maybeWhen(
        data: (plant) => plant != null
            ? Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkSurface
                      : AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textTertiary,
                              ),
                            ),
                            Text(
                              'Rs ${plant.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: plant.stock > 0
                            ? MyButton(
                                text: 'Add to Cart',
                                height: 50,
                                backgroundColor: AppColors.primary,
                                textColor: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                onPressed: () async {
                                  final networkInfo = ref.read(
                                    networkInfoProvider,
                                  );
                                  final isOnline =
                                      await networkInfo.isConnected;

                                  if (!isOnline) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'You are offline. Please go online to add items to cart.',
                                        ),
                                        backgroundColor: Colors.orange,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  ref
                                      .read(cartViewModelProvider.notifier)
                                      .addToCart(plant);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${plant.name} added to cart!',
                                      ),
                                      backgroundColor: AppColors.primary,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    'Out of Stock',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
        orElse: () => null,
      ),
    );
  }

  Widget _buildPlantDetails(BuildContext context, PlantEntity plant) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Image Carousel
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.42,
                width: double.infinity,
                child: plant.plantImages.isNotEmpty
                    ? PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemCount: plant.plantImages.length,
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: getFullImageUrl(plant.plantImages[index]),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppColors.surfaceVariant,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.surfaceVariant,
                              child: Icon(
                                Icons.local_florist,
                                size: 80,
                                color: AppColors.primary.withValues(alpha: 0.5),
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: AppColors.surfaceVariant,
                        child: Icon(
                          Icons.local_florist,
                          size: 80,
                          color: AppColors.primary.withValues(alpha: 0.5),
                        ),
                      ),
              ),
              // Gradient overlay for better visibility
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 80,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
              ),
              // Back Button
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              // Favorite Button
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                right: 16,
                child: Consumer(
                  builder: (context, ref, child) {
                    final favoritesState = ref.watch(
                      favoritesViewModelProvider,
                    );
                    final isFavorite = favoritesState.favorites.any(
                      (fav) => fav.plantId == plant.id,
                    );
                    return GestureDetector(
                      onTap: () {
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
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: isFavorite
                              ? Colors.red
                              : AppColors.textPrimary,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Page Indicator
              if (plant.plantImages.length > 1)
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      plant.plantImages.length,
                      (index) => AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primary
                              : Colors.white.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Container(
            transform: Matrix4.translationValues(0, -20, 0),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkBackground
                  : AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.15),
                          AppColors.primary.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.eco, size: 16, color: AppColors.primary),
                        SizedBox(width: 6),
                        Text(
                          plant.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    plant.name,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionHeader(
                    'Description',
                    Icons.description_outlined,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkSurfaceVariant
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      plant.description.isNotEmpty
                          ? plant.description
                          : 'No description available for this plant.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader(
                    'Availability',
                    Icons.inventory_2_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildStockStatus(plant.stock),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkTextPrimary
                : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStockStatus(int stock) {
    final bool isInStock = stock > 0;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isInStock
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isInStock
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isInStock
                  ? AppColors.success.withValues(alpha: 0.2)
                  : AppColors.error.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isInStock ? Icons.check_circle : Icons.cancel,
              color: isInStock ? AppColors.success : AppColors.error,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isInStock ? 'In Stock' : 'Out of Stock',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isInStock ? AppColors.success : AppColors.error,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  isInStock
                      ? '$stock items available'
                      : 'Currently unavailable',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
