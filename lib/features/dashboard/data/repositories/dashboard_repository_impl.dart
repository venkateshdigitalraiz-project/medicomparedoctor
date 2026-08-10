import 'package:medicompare/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:medicompare/features/dashboard/data/datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});
}
