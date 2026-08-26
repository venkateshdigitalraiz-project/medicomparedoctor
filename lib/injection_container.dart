import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:medicompare/core/network/global_client.dart';
import 'package:medicompare/features/call/core/services/webrtc_service.dart';
import 'package:medicompare/features/call/core/services/callkit_service.dart';
import 'package:medicompare/features/call/core/services/call_signaling_service.dart';
import 'package:medicompare/features/call/data/datasources/call_remote_data_source.dart';
import 'package:medicompare/features/call/domain/repositories/call_repository.dart';
import 'package:medicompare/features/call/data/repositories/call_repository_impl.dart';
import 'package:medicompare/features/call/presentation/bloc/call_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core / Network
  sl.registerLazySingleton<Dio>(() => AppHttpClient.dio);

  // Calling Feature
  _initCall();
}

void _initCall() {
  // Data Source
  sl.registerLazySingleton<CallRemoteDataSource>(
    () => CallRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // Services
  sl.registerLazySingleton(() => WebRTCService());
  sl.registerLazySingleton(() => CallKitService());
  sl.registerLazySingleton(() => CallSignalingService());

  // Repository
  sl.registerLazySingleton<CallRepository>(
    () => CallRepositoryImpl(signalingService: sl(), remoteDataSource: sl()),
  );

  // Bloc
  sl.registerFactory(
    () => CallBloc(
      webrtcService: sl(),
      callKitService: sl(),
      signalingService: sl(),
      callRepository: sl(),
    ),
  );
}
