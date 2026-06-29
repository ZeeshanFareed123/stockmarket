import 'package:flutter/material.dart';
import 'package:stockubl/app/theme/app_spacing.dart';

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      style: SegmentedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      ),
      segments: const [
        ButtonSegment(
          value: ThemeMode.system,
          label: Text('System', maxLines: 1),
        ),
        ButtonSegment(value: ThemeMode.light, label: Text('Light', maxLines: 1)),
        ButtonSegment(value: ThemeMode.dark, label: Text('Dark', maxLines: 1)),
      ],
      selected: {value},
      showSelectedIcon: false,
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}
