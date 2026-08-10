import 'package:medicompare/features/home/data/models/dashboard_response.dart';

abstract class HomeRepository {
  Future<DashboardResponse> fetchDashboard({
    required int page,
    required int limit,
  });
}
