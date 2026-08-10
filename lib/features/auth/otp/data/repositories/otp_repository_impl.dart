import 'package:medicompare/features/auth/otp/domain/repositories/otp_repository.dart';
import 'package:medicompare/features/auth/otp/data/datasources/otp_remote_data_source.dart';
import 'package:medicompare/features/auth/otp/data/models/verify_otp_response_model.dart';

class OtpRepositoryImpl implements OtpRepository {
  final OtpRemoteDataSource remoteDataSource;

  OtpRepositoryImpl({required this.remoteDataSource});

  @override
  Future<VerifyOtpResponseModel> verifyOtp({required String phone, required String otp}) async {
    return remoteDataSource.verifyOtp(phone: phone, otp: otp);
  }
}
