import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  final int selectedIndex;
  final Function(int) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.house,
            label: 'Home',
            isSelected: selectedIndex == 0,
            onTap: () => onItemTapped(0),
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.thLarge,
            label: 'Categories',
            isSelected: selectedIndex == 1,
            onTap: () => onItemTapped(1),
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.magnifyingGlass,
            label: 'Search',
            isSelected: selectedIndex == 2,
            onTap: () => onItemTapped(2),
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.cartShopping,
            label: 'Cart',
            isSelected: selectedIndex == 3,
            onTap: () => onItemTapped(3),
          ),
          _buildNavItem(
            context: context,
            icon: FontAwesomeIcons.user,
            label: 'Profile',
            isSelected: selectedIndex == 4,
            onTap: () => onItemTapped(4),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isSelected ? Colors.green.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: FaIcon(
              icon,
              size: 20,
              color: isSelected ? Colors.green : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.green : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
