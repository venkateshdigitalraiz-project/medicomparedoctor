import 'package:shared_preferences/shared_preferences.dart';

abstract class NotificationLocalDataSource {
  Future<String?> getFCMToken();
  Future<void> saveFCMToken(String token);
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  static const String _keyFcmToken = 'fcm_token';

  @override
  Future<String?> getFCMToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFcmToken);
  }

  @override
  Future<void> saveFCMToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFcmToken, token);
  }
}
