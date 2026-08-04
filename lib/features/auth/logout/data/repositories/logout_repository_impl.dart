import '../../domain/repositories/logout_repository.dart';
import '../datasources/logout_api_service.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  final LogoutApiService apiService;

  LogoutRepositoryImpl({required this.apiService});

  @override
  Future<void> logout() async {
    await apiService.logout();
  }
}
