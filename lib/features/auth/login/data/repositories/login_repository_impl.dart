import '../../domain/repositories/login_repository.dart';
import '../datasources/login_remote_data_source.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl({required this.remoteDataSource});

  @override
  Future<LoginResponseModel> login(String phone) async {
    return remoteDataSource.login(
      LoginRequestModel(
        loginType: 'phone',
        phone: phone,
      ),
    );
  }
}
