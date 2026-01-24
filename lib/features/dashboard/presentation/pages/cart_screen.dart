import 'package:flutter/material.dart';
import 'package:nurser_e/app/theme/theme_colors_extension.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SizedBox.expand(
        child: Center(
          child: Text(
            "This is Cart screen",
            style: TextStyle(
              color: context.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
