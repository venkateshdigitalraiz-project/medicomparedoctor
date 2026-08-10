import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:medicompare/core/network/global_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core / Network
  sl.registerLazySingleton<Dio>(() => AppHttpClient.dio);
}
