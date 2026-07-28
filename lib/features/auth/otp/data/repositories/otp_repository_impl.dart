import '../../domain/repositories/otp_repository.dart';
import '../datasources/otp_remote_data_source.dart';
import '../models/verify_otp_response_model.dart';

class OtpRepositoryImpl implements OtpRepository {
  final OtpRemoteDataSource remoteDataSource;

  OtpRepositoryImpl({required this.remoteDataSource});

  @override
  Future<VerifyOtpResponseModel> verifyOtp({required String phone, required String otp}) async {
    return remoteDataSource.verifyOtp(phone: phone, otp: otp);
  }
}
