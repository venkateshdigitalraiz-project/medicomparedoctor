import '../repositories/logout_repository.dart';

class LogoutUseCase {
  final LogoutRepository repository;

  LogoutUseCase({required this.repository});

  Future<void> call() async {
    await repository.logout();
  }
}
