import 'package:flutter/material.dart';

class MarketSearchField extends StatelessWidget {
  const MarketSearchField({
    required this.controller,
    required this.onChanged,
    required this.onFilterPressed,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterPressed;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search stocks, crypto, ETFs...',
        prefixIcon: const Icon(Icons.search_rounded, size: 28),
        suffixIcon: IconButton(
          tooltip: 'Filters',
          onPressed: onFilterPressed,
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            side: BorderSide.none,
            shape: const RoundedRectangleBorder(),
          ),
          icon: const Icon(Icons.tune_rounded),
        ),
      ),
    );
  }
}
