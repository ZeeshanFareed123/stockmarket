import 'package:flutter/material.dart';
import 'package:stockubl/app/theme/app_spacing.dart';

class AppTabPage extends StatelessWidget {
  const AppTabPage({
    required this.title,
    required this.subtitle,
    required this.child,
    this.actions = const [],
    this.showStatusIndicator = false,
    this.bottomPadding = AppSpacing.lg,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<Widget> actions;
  final Widget child;
  final bool showStatusIndicator;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          bottomPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.headlineMedium),
                      if (subtitle.trim().isNotEmpty ||
                          showStatusIndicator) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            if (showStatusIndicator) ...[
                              Container(
                                width: 9,
                                height: 9,
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                            ],
                            Flexible(
                              child: Text(
                                subtitle,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (actions.isNotEmpty) ...[
                  const SizedBox(width: AppSpacing.md),
                  Wrap(spacing: AppSpacing.sm, children: actions),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
