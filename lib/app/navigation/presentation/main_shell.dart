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
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _selectTab,
        destinations: AppTab.values
            .map((tab) => tab.toDestination())
            .toList(growable: false),
      ),
    );
  }
}
