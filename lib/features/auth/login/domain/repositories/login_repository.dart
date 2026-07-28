import '../../data/models/login_response_model.dart';

abstract class LoginRepository {
  Future<LoginResponseModel> login(String phone);
}
