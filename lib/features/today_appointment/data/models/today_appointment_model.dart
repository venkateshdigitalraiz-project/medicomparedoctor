import 'package:medicompare/features/today_appointment/domain/entities/today_appointment_entity.dart';

class TodayAppointmentModel extends TodayAppointmentEntity {
  const TodayAppointmentModel({
    required super.id,
    required super.userId,
    required super.patientId,
    required super.name,
    required super.phone,
    required super.email,
    required super.city,
    required super.age,
    required super.message,
    required super.preferredTime,
    required super.status,
    required super.avatarUrl,
  });

  factory TodayAppointmentModel.fromJson(Map<String, dynamic> json) {
    return TodayAppointmentModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? json['userId']?.toString() ?? '',
      name: json['name']?.toString() ??
          json['patientName']?.toString() ??
          json['user']?['name']?.toString() ??
          '',
      phone: json['phone']?.toString() ??
          json['user']?['phone']?.toString() ??
          '',
      email: json['email']?.toString() ??
          json['user']?['email']?.toString() ??
          '',
      city: json['city']?.toString() ??
          json['user']?['city']?.toString() ??
          '',
      age: int.tryParse(json['age']?.toString() ??
              json['user']?['age']?.toString() ??
              '0') ??
          0,
      message: json['message']?.toString() ??
          json['user']?['message']?.toString() ??
          '',
      preferredTime: json['preferredTime']?.toString() ??
          json['time']?.toString() ??
          '',
      status: json['status']?.toString() ?? 'pending',
      avatarUrl: json['avatarUrl']?.toString() ??
          json['profileImage']?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'patientId': patientId,
      'name': name,
      'phone': phone,
      'email': email,
      'city': city,
      'age': age,
      'message': message,
      'preferredTime': preferredTime,
      'status': status,
      'avatarUrl': avatarUrl,
    };
  }
}
