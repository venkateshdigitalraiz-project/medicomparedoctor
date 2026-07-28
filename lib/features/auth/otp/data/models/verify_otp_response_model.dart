class VerifyOtpResponseModel {
  final bool success;
  final String message;
  final VerifyOtpData? data;
  final dynamic errors;
  final dynamic users;

  const VerifyOtpResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.users,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? VerifyOtpData.fromJson(json['data']) : null,
      errors: json['errors'],
      users: json['users'],
    );
  }
}

class VerifyOtpData {
  final String token;
  final EmployeePerson? employeePerson;

  const VerifyOtpData({
    required this.token,
    this.employeePerson,
  });

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(
      token: json['token'] ?? '',
      employeePerson: json['employeePerson'] != null
          ? EmployeePerson.fromJson(json['employeePerson'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'employeePerson': employeePerson?.toJson(),
    };
  }
}

class EmployeePerson {
  final String id;
  final String name;
  final String email;

  const EmployeePerson({
    required this.id,
    required this.name,
    required this.email,
  });

  factory EmployeePerson.fromJson(Map<String, dynamic> json) {
    return EmployeePerson(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
