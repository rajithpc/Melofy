import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key, required this.hintValue, required this.onSearch});
  final String hintValue;
  final Function(String) onSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 40,
      child: TextField(
        onChanged: onSearch,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          hintText: hintValue,
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(0),
        ),
      ),
    );
  }
}
