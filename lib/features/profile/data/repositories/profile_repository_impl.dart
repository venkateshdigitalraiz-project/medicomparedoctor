import 'package:medicompare/features/profile/data/models/user_profile_model.dart';

import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_api_service.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final ProfileApiService apiService;

  UserProfileRepositoryImpl({required this.apiService});

  @override
  Future<UserProfileModel> getUserProfile() async {
    return await apiService.fetchProfile();
  }
}
