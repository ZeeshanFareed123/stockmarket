import 'package:flutter/material.dart';
import 'package:stockubl/app/theme/app_spacing.dart';

class TextScaleSelector extends StatelessWidget {
  const TextScaleSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        Row(
          children: [
            Text('A', style: theme.textTheme.bodySmall),
            Expanded(
              child: Slider(
                value: value.clamp(0.8, 1.2),
                min: 0.8,
                max: 1.2,
                divisions: 4,
                label: '${(value * 100).round()}%',
                onChanged: onChanged,
              ),
            ),
            Text('A', style: theme.textTheme.titleLarge),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Preview: Markets move, your view stays clear.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
