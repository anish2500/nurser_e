import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/app/theme/theme_colors_extension.dart';
import 'package:nurser_e/app/theme/app_colors.dart';
import 'package:nurser_e/core/api/api_endpoints.dart';
import 'package:nurser_e/core/widgets/product_card.dart';
import 'package:nurser_e/features/favorites/presentation/state/favorite_state.dart';
import 'package:nurser_e/features/favorites/presentation/view_model/favorite_view_model.dart';
import 'package:nurser_e/features/plants/presentation/pages/view_plant_screen.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoritesViewModelProvider.notifier).loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesState = ref.watch(favoritesViewModelProvider);
    final primaryGreen = Colors.green;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                'Favorites',
                style: TextStyle(
                  fontFamily: 'Poppins Bold',
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                  color: primaryGreen,
                ),
              ),
            ),
            Expanded(child: _buildBody(favoritesState)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(FavoriteState favoritesState) {
    if (favoritesState.status == FavoriteStatus.loading) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (favoritesState.status == FavoriteStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Error loading favorites',
              style: TextStyle(color: AppColors.error),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.read(favoritesViewModelProvider.notifier).loadFavorites();
              },
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (favoritesState.favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Add plants to your favorites',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: favoritesState.favorites.length,
      itemBuilder: (context, index) {
        final fav = favoritesState.favorites[index];
        return ProductCard(
          title: fav.name,
          price: 'Rs ${fav.price.toStringAsFixed(2)}',
          categories: fav.category,
          imagePath: fav.plantImages.isNotEmpty
              ? '${ApiEndpoints.imageBaseUrl}/plant_images/${fav.plantImages.first}'
              : null,
          isNetworkImage: true,
          isFavorite: true,
          onFavoriteToggle: () {
            ref
                .read(favoritesViewModelProvider.notifier)
                .removeFromFavorites(fav.plantId);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${fav.name} removed from favorites'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 1),
              ),
            );
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewPlantScreen(plantId: fav.plantId),
              ),
            );
          },
        );
      },
    );
  }
}
