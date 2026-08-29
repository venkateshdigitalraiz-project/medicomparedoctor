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
import 'package:medicompare/features/today_appointment/data/datasources/today_appointment_remote_data_source.dart';
import 'package:medicompare/features/today_appointment/domain/repositories/today_appointment_repository.dart';
import 'package:medicompare/features/today_appointment/data/repositories/today_appointment_repository_impl.dart';
import 'package:medicompare/features/today_appointment/domain/usecases/get_today_appointments_usecase.dart';
import 'package:medicompare/features/today_appointment/presentation/bloc/appointment_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core / Network
  sl.registerLazySingleton<Dio>(() => AppHttpClient.dio);

  // Calling Feature
  _initCall();

  // Today's Appointments Feature
  _initTodayAppointments();
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
  sl.registerLazySingleton(
    () => CallBloc(
      webrtcService: sl(),
      callKitService: sl(),
      signalingService: sl(),
      callRepository: sl(),
    ),
  );
}

void _initTodayAppointments() {
  // Data Source
  sl.registerLazySingleton<TodayAppointmentRemoteDataSource>(
    () => TodayAppointmentRemoteDataSourceImpl(client: sl<Dio>()),
  );

  // Repository
  sl.registerLazySingleton<TodayAppointmentRepository>(
    () => TodayAppointmentRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => GetTodayAppointmentsUseCase(sl<TodayAppointmentRepository>()),
  );

  // Bloc
  sl.registerFactory(
    () => AppointmentBloc(getTodayAppointmentsUseCase: sl()),
  );
}

