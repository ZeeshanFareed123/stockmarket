enum AppFontFamily {
  system,
  sansSerif,
  serif,
  monospace;

  String get label => switch (this) {
    AppFontFamily.system => 'System',
    AppFontFamily.sansSerif => 'Sans Serif',
    AppFontFamily.serif => 'Serif',
    AppFontFamily.monospace => 'Monospace',
  };

  String? get familyName => switch (this) {
    AppFontFamily.system => null,
    AppFontFamily.sansSerif => 'sans-serif',
    AppFontFamily.serif => 'serif',
    AppFontFamily.monospace => 'monospace',
  };
}
