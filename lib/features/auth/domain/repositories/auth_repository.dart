import 'package:medicompare/features/auth/login/data/models/login_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login(String phone);
}
