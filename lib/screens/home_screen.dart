import 'package:flutter/material.dart';
import 'package:nurser_e/widgets/bottom_navigation.dart';
import 'package:nurser_e/widgets/my_button.dart';
import 'package:nurser_e/widgets/search_textfield.dart';
import 'package:nurser_e/screens/categories_screen.dart';
import 'package:nurser_e/screens/search_screen.dart';
import 'package:nurser_e/screens/cart_screen.dart';
import 'package:nurser_e/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to respective screens
    switch (index) {
      case 1: // Categories
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CategoriesScreen()),
        );
        break;
      case 2: // Search
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
        break;
      case 3: // Cart
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
        break;
      case 4: // Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SearchTextField(
                controller: TextEditingController(),
                hint: 'Search plants...',
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildNewArrivalsSection(),
                    
                    const SizedBox(height: 30),
                    
                    _buildPlantSection(
                      title: 'Indoor Plants',
                      priceText: 'Starts from 1500 NPR',
                      plants: [
                        {'name': 'Monstera Deliciosa', 'image': 'assets/images/plant1.jpg'},
                        {'name': 'Snake Plant', 'image': 'assets/images/plant2.jpg'},
                        {'name': 'Peace Lily', 'image': 'assets/images/plant3.jpg'},
                        {'name': 'Pothos', 'image': 'assets/images/plant1.jpg'},
                        {'name': 'ZZ Plant', 'image': 'assets/images/plant2.jpg'},
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    _buildPlantSection(
                      title: 'Outdoor Plants',
                      priceText: 'Starts from 2000 NPR',
                      plants: [
                        {'name': 'Fiddle Leaf Fig', 'image': 'assets/images/plant3.jpg'},
                        {'name': 'Rubber Plant', 'image': 'assets/images/plant1.jpg'},
                        {'name': 'Bird of Paradise', 'image': 'assets/images/plant2.jpg'},
                        {'name': 'Olive Tree', 'image': 'assets/images/plant3.jpg'},
                        {'name': 'Palm Tree', 'image': 'assets/images/plant1.jpg'},
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    _buildPlantSection(
                      title: 'Seeds & Bulbs',
                      priceText: 'Starts from 500 NPR',
                      plants: [
                        {'name': 'Basil Seeds', 'image': 'assets/images/plant2.jpg'},
                        {'name': 'Tomato Seeds', 'image': 'assets/images/plant3.jpg'},
                        {'name': 'Sunflower Seeds', 'image': 'assets/images/plant1.jpg'},
                        {'name': 'Rose Bulbs', 'image': 'assets/images/plant2.jpg'},
                        {'name': 'Tulip Bulbs', 'image': 'assets/images/plant3.jpg'},
                      ],
                    ),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildNewArrivalsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New Arrivals',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Check out our latest collection of beautiful plants',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          MyButton(
            text: 'Checkout Now',
            color: Colors.white,
            onPressed: () {},
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: Colors.green,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCircularPlantImage('assets/images/plant1.jpg'),
              _buildCircularPlantImage('assets/images/plant2.jpg'),
              _buildCircularPlantImage('assets/images/plant3.jpg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularPlantImage(String imagePath) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: ClipOval(
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.white.withOpacity(0.3),
              child: const Icon(
                Icons.local_florist,
                color: Colors.white,
                size: 30,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlantSection({
    required String title,
    required String priceText,
    required List<Map<String, String>> plants,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Text(
                priceText,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: plants.length,
              itemBuilder: (context, index) {
                final plant = plants[index];
                return Padding(
                  padding: EdgeInsets.only(right: index == plants.length - 1 ? 0 : 12),
                  child: SizedBox(
                    width: 160,
                    child: _buildPlantCard(
                      name: plant['name']!,
                      imagePath: plant['image']!,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'View All >>',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantCard({
    required String name,
    required String imagePath,
  }) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.local_florist,
                        color: Colors.grey,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
