import 'package:flutter/material.dart';
import 'package:nurser_e/features/dashboard/presentation/pages/about_screen.dart';
import 'package:nurser_e/features/dashboard/presentation/pages/cart_screen.dart';
import 'package:nurser_e/features/dashboard/presentation/pages/categories_screen.dart';
import 'package:nurser_e/features/dashboard/presentation/pages/home_screen.dart';
import 'package:nurser_e/features/dashboard/presentation/pages/profile_screen.dart';

class BottomNavigationLayout extends StatefulWidget {
  const BottomNavigationLayout({super.key});

  @override
  State<BottomNavigationLayout> createState() => _BottomNavigationLayoutState();
}

class _BottomNavigationLayoutState extends State<BottomNavigationLayout> {
  int _selectedIndex = 0;

  List<Widget> lstBottomScreen = [
    const HomeScreen(),
    const CartScreen(),
    const CategoriesScreen(),
    const ProfileScreen(),
    const AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: lstBottomScreen[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline_rounded),
            label: 'About Us',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}