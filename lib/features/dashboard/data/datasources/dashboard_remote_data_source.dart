import 'package:dio/dio.dart';

abstract class DashboardRemoteDataSource {
  // Placeholder for dashboard remote data interactions
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio client;

  DashboardRemoteDataSourceImpl({required this.client});
}
