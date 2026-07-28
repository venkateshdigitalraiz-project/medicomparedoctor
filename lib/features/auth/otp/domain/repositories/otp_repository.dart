import '../../data/models/verify_otp_response_model.dart';

abstract class OtpRepository {
  Future<VerifyOtpResponseModel> verifyOtp({required String phone, required String otp});
}
