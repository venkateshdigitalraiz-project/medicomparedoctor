class LoginRequestModel {
  final String loginType;
  final String phone;
  final String? fcmToken;

  const LoginRequestModel({
    required this.loginType,
    required this.phone,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'loginType': loginType,
      'phone': phone,
      if (fcmToken != null) 'appfcmToken': fcmToken,
    };
  }
}
