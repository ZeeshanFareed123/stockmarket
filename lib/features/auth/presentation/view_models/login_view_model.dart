import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stockubl/features/auth/data/auth_repository_provider.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  FutureOr<void> build() {}

  Future<void> start() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      ref.read(authRepositoryProvider).startSession,
    );
  }
}
