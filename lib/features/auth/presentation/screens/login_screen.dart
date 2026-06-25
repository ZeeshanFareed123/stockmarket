import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stockubl/app/router/app_routes.dart';
import 'package:stockubl/app/theme/app_radius.dart';
import 'package:stockubl/app/theme/app_spacing.dart';
import 'package:stockubl/features/auth/presentation/view_models/login_view_model.dart';
import 'package:stockubl/features/auth/presentation/widgets/start_button.dart';
import 'package:stockubl/shared/presentation/feedback/app_snackbar.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(loginViewModelProvider, (previous, next) {
      if (previous?.isLoading != true) {
        return;
      }

      if (next.hasError) {
        AppSnackbar.error(context, 'Unable to start. Please try again.');
      } else if (next.hasValue) {
        context.goNamed(AppRoute.home.name);
      }
    });

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(AppRadius.large),
                      ),
                      child: Icon(
                        Icons.show_chart_rounded,
                        color: colors.onPrimaryContainer,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'StockUBL',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Invest with clarity.',
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'A clean foundation for secure investing, live market '
                    'data, portfolio insights, and future trading features.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const StartButton(),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Mock environment · Android & iOS',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
