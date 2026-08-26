import 'package:shared_preferences/shared_preferences.dart';
import '../services/session_manager.dart';

class LocalStorageService {
  Future<String?> getToken() async {
    return await SessionManager.getToken();
  }

  Future<String?> getUserId() async {
    final user = await SessionManager.getUserData();
    if (user != null) {
      return user['_id']?.toString() ??
          user['id']?.toString() ??
          user['userId']?.toString() ??
          user['doctorId']?.toString();
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id') ?? prefs.getString('doctor_id');
  }
}
