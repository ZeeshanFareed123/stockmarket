import 'package:flutter/material.dart';

class AppHeaderAction extends StatelessWidget {
  const AppHeaderAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.showIndicator = false,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Badge(
      isLabelVisible: showIndicator,
      smallSize: 8,
      backgroundColor: colors.primary,
      child: IconButton.outlined(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}
