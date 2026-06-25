import 'package:flutter/material.dart';
import 'package:stockubl/shared/presentation/components/app_empty_state.dart';
import 'package:stockubl/shared/presentation/components/app_header_action.dart';
import 'package:stockubl/shared/presentation/layouts/app_tab_page.dart';

class MarketsScreen extends StatelessWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTabPage(
      title: 'Markets',
      subtitle: 'Global markets at a glance',
      actions: [
        AppHeaderAction(
          icon: Icons.search_rounded,
          tooltip: 'Search markets',
          onPressed: () {},
        ),
        AppHeaderAction(
          icon: Icons.notifications_outlined,
          tooltip: 'Market alerts',
          onPressed: () {},
        ),
      ],
      child: const AppEmptyState(
        icon: Icons.candlestick_chart_rounded,
        title: 'Explore the markets',
        message:
            'Stocks, indices, commodities, ETFs, live prices, and market '
            'search will appear here.',
      ),
    );
  }
}
