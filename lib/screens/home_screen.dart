import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Screen',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width >= 768 ? 28 : 24,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'This is home screen', 
          style: TextStyle(
            color: Colors.blue, 
            fontSize: MediaQuery.of(context).size.width >= 768 ? 32 : 24
          ),
        ),
      ),
    );
  }
}