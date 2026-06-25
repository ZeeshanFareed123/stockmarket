import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockubl/app/settings/application/app_settings_controller.dart';
import 'package:stockubl/app/theme/app_spacing.dart';
import 'package:stockubl/features/settings/presentation/widgets/color_palette_selector.dart';
import 'package:stockubl/features/settings/presentation/widgets/font_family_selector.dart';
import 'package:stockubl/features/settings/presentation/widgets/settings_section.dart';
import 'package:stockubl/features/settings/presentation/widgets/text_scale_selector.dart';
import 'package:stockubl/features/settings/presentation/widgets/theme_mode_selector.dart';
import 'package:stockubl/shared/presentation/components/app_header_action.dart';
import 'package:stockubl/shared/presentation/layouts/app_tab_page.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsControllerProvider);
    final controller = ref.read(appSettingsControllerProvider.notifier);

    return AppTabPage(
      title: 'Settings',
      subtitle: 'Personalize your experience',
      actions: [
        AppHeaderAction(
          icon: Icons.person_outline_rounded,
          tooltip: 'Profile',
          onPressed: () {},
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
        children: [
          SettingsSection(
            title: 'Appearance',
            description:
                'Follow your device theme or choose a fixed light or dark '
                'experience.',
            child: ThemeModeSelector(
              value: settings.themeMode,
              onChanged: controller.setThemeMode,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SettingsSection(
            title: 'Color theme',
            description:
                'The accent updates buttons, selected tabs, highlights, and '
                'interactive controls across the app.',
            child: ColorPaletteSelector(
              value: settings.colorPalette,
              onChanged: controller.setColorPalette,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SettingsSection(
            title: 'Typography',
            description:
                'Choose an app-wide font style and adjust readability.',
            child: Column(
              children: [
                FontFamilySelector(
                  value: settings.fontFamily,
                  onChanged: controller.setFontFamily,
                ),
                const SizedBox(height: AppSpacing.md),
                TextScaleSelector(
                  value: settings.textScaleFactor,
                  onChanged: controller.setTextScaleFactor,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: controller.reset,
            icon: const Icon(Icons.restart_alt_rounded),
            label: const Text('Reset appearance'),
          ),
        ],
      ),
    );
  }
}
