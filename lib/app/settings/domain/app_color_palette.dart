enum AppColorPalette {
  indigo,
  graphiteGold,
  teal,
  plum,
  coral;

  String get label => switch (this) {
    AppColorPalette.indigo => 'Indigo',
    AppColorPalette.graphiteGold => 'Graphite & Gold',
    AppColorPalette.teal => 'Teal',
    AppColorPalette.plum => 'Plum',
    AppColorPalette.coral => 'Coral',
  };
}
