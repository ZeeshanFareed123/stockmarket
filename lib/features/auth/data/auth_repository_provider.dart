import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stockubl/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:stockubl/features/auth/domain/repositories/auth_repository.dart';

part 'auth_repository_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return const MockAuthRepository();
}
