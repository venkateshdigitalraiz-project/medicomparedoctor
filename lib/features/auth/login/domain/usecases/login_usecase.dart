import 'package:medicompare/features/auth/login/domain/repositories/login_repository.dart';
import 'package:medicompare/features/auth/login/data/models/login_response_model.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);

  Future<LoginResponseModel> call(String phone, {String? fcmToken}) async {
    return await repository.login(phone, fcmToken: fcmToken);
  }
}
