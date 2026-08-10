import 'package:medicompare/features/auth/otp/domain/repositories/otp_repository.dart';
import 'package:medicompare/features/auth/otp/data/models/verify_otp_response_model.dart';

class VerifyOtpUseCase {
  final OtpRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<VerifyOtpResponseModel> call({required String phone, required String otp}) async {
    return await repository.verifyOtp(phone: phone, otp: otp);
  }
}
