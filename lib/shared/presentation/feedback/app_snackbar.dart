import 'package:flutter/material.dart';

abstract final class AppSnackbar {
  static void info(BuildContext context, String message) {
    _show(context, message: message, icon: Icons.info_outline_rounded);
  }

  static void success(BuildContext context, String message) {
    _show(context, message: message, icon: Icons.check_circle_outline_rounded);
  }

  static void error(BuildContext context, String message) {
    _show(context, message: message, icon: Icons.error_outline_rounded);
  }

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
  }
}
