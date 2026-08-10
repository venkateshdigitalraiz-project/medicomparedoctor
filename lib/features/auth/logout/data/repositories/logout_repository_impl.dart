import 'package:medicompare/features/auth/logout/domain/repositories/logout_repository.dart';
import 'package:medicompare/features/auth/logout/data/datasources/logout_api_service.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  final LogoutApiService apiService;

  LogoutRepositoryImpl({required this.apiService});

  @override
  Future<void> logout() async {
    await apiService.logout();
  }
}
