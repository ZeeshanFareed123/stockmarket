import 'package:flutter/material.dart';

class MarketSearchField extends StatelessWidget {
  const MarketSearchField({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        hintText: 'Search stocks...',
        prefixIcon: const Icon(Icons.search_rounded, size: 24),
      ),
    );
  }
}
