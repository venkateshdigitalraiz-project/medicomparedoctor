import 'package:medicompare/features/auth/logout/data/repositories/logout_repository_impl.dart';
import 'package:medicompare/features/auth/logout/domain/repositories/logout_repository.dart';

class LogoutUseCase {
  final LogoutRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() async {
    return await repository.logout();
  }
}
