enum AppFontFamily {
  system,
  sansSerif,
  poppinsLight,
  serif,
  monospace;

  String get label => switch (this) {
    AppFontFamily.system => 'Device',
    AppFontFamily.sansSerif => 'Modern',
    AppFontFamily.poppinsLight => 'Poppins Light',
    AppFontFamily.serif => 'Editorial',
    AppFontFamily.monospace => 'Mono',
  };

  String? get familyName => switch (this) {
    AppFontFamily.system => null,
    AppFontFamily.sansSerif => 'Inter',
    AppFontFamily.poppinsLight => 'PoppinsLight',
    AppFontFamily.serif => 'Lora',
    AppFontFamily.monospace => 'JetBrainsMono',
  };
}
