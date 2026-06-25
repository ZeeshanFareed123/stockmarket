import 'package:flutter/material.dart';
import 'package:stockubl/shared/presentation/components/app_empty_state.dart';
import 'package:stockubl/shared/presentation/components/app_header_action.dart';
import 'package:stockubl/shared/presentation/layouts/app_tab_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTabPage(
      title: 'Good morning, Alex',
      subtitle: 'Markets are open',
      showStatusIndicator: true,
      actions: [
        AppHeaderAction(
          icon: Icons.person_outline_rounded,
          tooltip: 'Profile',
          onPressed: () {},
        ),
        AppHeaderAction(
          icon: Icons.search_rounded,
          tooltip: 'Search',
          onPressed: () {},
        ),
        AppHeaderAction(
          icon: Icons.notifications_outlined,
          tooltip: 'Notifications',
          showIndicator: true,
          onPressed: () {},
        ),
      ],
      child: const AppEmptyState(
        icon: Icons.home_rounded,
        title: 'Home dashboard',
        message:
            'Portfolio summary, quick actions, market pulse, watchlist, '
            'and recent activity will appear here.',
      ),
    );
  }
}
