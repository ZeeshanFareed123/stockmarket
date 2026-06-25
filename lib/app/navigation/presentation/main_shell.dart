import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stockubl/app/navigation/domain/app_tab.dart';

class MainShell extends StatelessWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _selectTab(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: colors.outline),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _selectTab,
              destinations: AppTab.values
                  .map((tab) => tab.toDestination())
                  .toList(growable: false),
            ),
          ),
        ),
      ),
    );
  }
}
