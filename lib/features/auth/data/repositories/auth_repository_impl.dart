import 'package:medicompare/features/auth/login/data/models/login_request_model.dart';
import 'package:medicompare/features/auth/login/data/models/login_response_model.dart';
import 'package:medicompare/notification/data/datasources/notification_local_data_source.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<LoginResponseModel> login(String phone) async {
    final localDataSource = NotificationLocalDataSourceImpl();
    final fcmToken = await localDataSource.getFCMToken();
    return remoteDataSource.login(
      LoginRequestModel(loginType: 'phone', phone: phone, fcmToken: fcmToken),
    );
  }
}
