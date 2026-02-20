import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(
            fontFamily: "Poppins Regular",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Center(
        child: Text(
          'Your orders are here!',
          style: TextStyle(
            fontFamily: "Poppins Regular",
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
