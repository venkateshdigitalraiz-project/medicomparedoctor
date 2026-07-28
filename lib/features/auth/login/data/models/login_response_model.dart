class LoginResponseModel {
  final bool success;
  final String message;
  final LoginData? data;

  const LoginResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
    );
  }
}

class LoginData {
  final String phone;

  const LoginData({
    required this.phone,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      phone: (json['phone'] ?? '').toString(),
    );
  }
}
