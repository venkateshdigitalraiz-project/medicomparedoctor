import 'package:medicompare/features/auth/login/domain/repositories/login_repository.dart';
import 'package:medicompare/features/auth/login/data/datasources/login_remote_data_source.dart';
import 'package:medicompare/features/auth/login/data/models/login_request_model.dart';
import 'package:medicompare/features/auth/login/data/models/login_response_model.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl({required this.remoteDataSource});

  @override
  Future<LoginResponseModel> login(String phone, {String? fcmToken}) async {
    return remoteDataSource.login(
      LoginRequestModel(
        loginType: 'phone',
        phone: phone,
        fcmToken: fcmToken,
      ),
    );
  }
}
