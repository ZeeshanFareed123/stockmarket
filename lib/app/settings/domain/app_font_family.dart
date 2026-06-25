enum AppFontFamily {
  system,
  sansSerif,
  serif,
  monospace;

  String get label => switch (this) {
    AppFontFamily.system => 'Device',
    AppFontFamily.sansSerif => 'Modern',
    AppFontFamily.serif => 'Editorial',
    AppFontFamily.monospace => 'Mono',
  };

  String? get familyName => switch (this) {
    AppFontFamily.system => null,
    AppFontFamily.sansSerif => 'Inter',
    AppFontFamily.serif => 'Lora',
    AppFontFamily.monospace => 'JetBrainsMono',
  };
}
