import 'package:medicompare/features/profile/data/models/user_profile_model.dart';

abstract class UserProfileRepository {
  Future<UserProfileModel> getUserProfile();
}
