import 'package:flutter/material.dart';
import 'package:stockubl/shared/presentation/components/app_empty_state.dart';
import 'package:stockubl/shared/presentation/components/app_header_action.dart';
import 'package:stockubl/shared/presentation/layouts/app_tab_page.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTabPage(
      title: 'Portfolio',
      subtitle: 'Your investments',
      actions: [
        AppHeaderAction(
          icon: Icons.visibility_outlined,
          tooltip: 'Hide balances',
          onPressed: () {},
        ),
        AppHeaderAction(
          icon: Icons.tune_rounded,
          tooltip: 'Portfolio filters',
          onPressed: () {},
        ),
      ],
      child: const AppEmptyState(
        icon: Icons.pie_chart_rounded,
        title: 'Your portfolio',
        message:
            'Total value, profit and loss, allocation, holdings, and orders '
            'will appear here.',
      ),
    );
  }
}
