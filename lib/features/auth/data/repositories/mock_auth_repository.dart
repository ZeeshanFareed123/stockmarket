import 'package:stockubl/features/auth/domain/repositories/auth_repository.dart';

final class MockAuthRepository implements AuthRepository {
  const MockAuthRepository();

  @override
  Future<void> startSession() {
    return Future<void>.delayed(const Duration(milliseconds: 700));
  }
}
