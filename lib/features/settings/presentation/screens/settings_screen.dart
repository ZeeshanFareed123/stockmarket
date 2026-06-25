import 'package:flutter/material.dart';
import 'package:stockubl/shared/presentation/components/app_empty_state.dart';
import 'package:stockubl/shared/presentation/components/app_header_action.dart';
import 'package:stockubl/shared/presentation/layouts/app_tab_page.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTabPage(
      title: 'Settings',
      subtitle: 'Preferences and security',
      actions: [
        AppHeaderAction(
          icon: Icons.person_outline_rounded,
          tooltip: 'Profile',
          onPressed: () {},
        ),
      ],
      child: const AppEmptyState(
        icon: Icons.settings_rounded,
        title: 'App settings',
        message:
            'Appearance, security, notifications, accessibility, support, '
            'and legal preferences will appear here.',
      ),
    );
  }
}
