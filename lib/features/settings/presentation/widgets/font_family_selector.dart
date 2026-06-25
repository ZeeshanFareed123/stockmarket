import 'package:flutter/material.dart';
import 'package:stockubl/app/settings/domain/app_font_family.dart';

class FontFamilySelector extends StatelessWidget {
  const FontFamilySelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final AppFontFamily value;
  final ValueChanged<AppFontFamily> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<AppFontFamily>(
      initialValue: value,
      decoration: const InputDecoration(
        labelText: 'App font',
        prefixIcon: Icon(Icons.text_fields_rounded),
      ),
      items: AppFontFamily.values
          .map((font) {
            return DropdownMenuItem(
              value: font,
              child: Text(
                '${font.label} · Aa',
                style: TextStyle(fontFamily: font.familyName),
              ),
            );
          })
          .toList(growable: false),
      onChanged: (font) {
        if (font != null) {
          onChanged(font);
        }
      },
    );
  }
}
