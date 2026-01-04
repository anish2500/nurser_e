import 'package:flutter/material.dart';
import 'package:nurser_e/core/widgets/my_textfield.dart';

class my_searchbox extends StatefulWidget {
  const my_searchbox({super.key});

  @override
  State<my_searchbox> createState() => _my_searchboxState();
}

class _my_searchboxState extends State<my_searchbox> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins Regular',
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: 'Search for items...',
            hintStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
              fontFamily: 'Poppins Regular',
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey.shade600,
              size: 20,
            ),
            suffixIcon: Icon(
              Icons.trending_up,
              color: Colors.green.shade400,
              size: 20,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: InputBorder.none,
            filled: false,
          ),
        ),
      ),
    );
  }
}
