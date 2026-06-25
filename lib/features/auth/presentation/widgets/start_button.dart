import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockubl/features/auth/presentation/view_models/login_view_model.dart';
import 'package:stockubl/shared/presentation/components/app_button.dart';

class StartButton extends ConsumerWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);

    return AppButton(
      label: 'Start',
      icon: Icons.arrow_forward_rounded,
      isLoading: state.isLoading,
      onPressed: () => ref.read(loginViewModelProvider.notifier).start(),
    );
  }
}
