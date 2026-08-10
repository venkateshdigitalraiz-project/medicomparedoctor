import 'package:medicompare/features/home/domain/repositories/home_repository.dart';
import 'package:medicompare/features/home/data/models/dashboard_response.dart';

class GetDashboardUseCase {
  final HomeRepository repository;

  GetDashboardUseCase(this.repository);

  Future<DashboardResponse> call({required int page, required int limit}) async {
    return await repository.fetchDashboard(page: page, limit: limit);
  }
}
