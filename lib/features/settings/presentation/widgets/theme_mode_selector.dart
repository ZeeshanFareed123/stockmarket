import 'package:flutter/material.dart';

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
      segments: const [
        ButtonSegment(
          value: ThemeMode.system,
          icon: Icon(Icons.brightness_auto_outlined),
          label: Text('System'),
        ),
        ButtonSegment(
          value: ThemeMode.light,
          icon: Icon(Icons.light_mode_outlined),
          label: Text('Light'),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          icon: Icon(Icons.dark_mode_outlined),
          label: Text('Dark'),
        ),
      ],
      selected: {value},
      showSelectedIcon: false,
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}
