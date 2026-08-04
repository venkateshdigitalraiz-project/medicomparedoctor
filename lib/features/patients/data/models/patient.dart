enum PatientStatus { completed, waiting, cancelled }

class Patient {
  final String id;
  final String name;
  final String pid;
  final int age;
  final String gender;
  final String phone;
  final String lastVisit;
  final String avatarUrl;
  final PatientStatus status;

  const Patient({
    required this.id,
    required this.name,
    required this.pid,
    required this.age,
    required this.gender,
    required this.phone,
    required this.lastVisit,
    required this.avatarUrl,
    required this.status,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    PatientStatus statusValue = PatientStatus.waiting;
    final statusStr = json['status']?.toString().toLowerCase();
    if (statusStr == 'completed') {
      statusValue = PatientStatus.completed;
    } else if (statusStr == 'cancelled' || statusStr == 'cancel') {
      statusValue = PatientStatus.cancelled;
    } else if (statusStr == 'waiting') {
      statusValue = PatientStatus.waiting;
    }

    int ageVal = 0;
    if (json['age'] != null) {
      if (json['age'] is num) {
        ageVal = (json['age'] as num).toInt();
      } else {
        ageVal = int.tryParse(json['age'].toString()) ?? 0;
      }
    }

    return Patient(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      pid: json['patientId']?.toString() ?? '',
      age: ageVal,
      gender: json['gender']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      lastVisit: json['lastVisit']?.toString() ?? (json['createdAt']?.toString() ?? ''),
      avatarUrl: json['image']?.toString() ?? 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      status: statusValue,
    );
  }
}

class PatientStatistics {
  final int totalPatients;
  final int newThisMonth;
  final int waiting;
  final int completed;
  final int cancelled;

  const PatientStatistics({
    required this.totalPatients,
    required this.newThisMonth,
    required this.waiting,
    required this.completed,
    required this.cancelled,
  });

  factory PatientStatistics.fromJson(Map<String, dynamic> json) {
    return PatientStatistics(
      totalPatients: json['totalPatients'] as int? ?? 0,
      newThisMonth: json['newThisMonth'] as int? ?? 0,
      waiting: json['waiting'] as int? ?? 0,
      completed: json['completed'] as int? ?? 0,
      cancelled: json['cancelled'] as int? ?? 0,
    );
  }
}

class PatientPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const PatientPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PatientPagination.fromJson(Map<String, dynamic> json) {
    return PatientPagination(
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      total: json['total'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

class PatientListResponse {
  final PatientStatistics statistics;
  final PatientPagination pagination;
  final List<Patient> patients;

  const PatientListResponse({
    required this.statistics,
    required this.pagination,
    required this.patients,
  });

  factory PatientListResponse.fromJson(Map<String, dynamic> json) {
    final statsJson = json['statistics'] as Map<String, dynamic>? ?? {};
    final pagJson = json['pagination'] as Map<String, dynamic>? ?? {};
    final patientsList = json['patients'] as List<dynamic>? ?? [];

    return PatientListResponse(
      statistics: PatientStatistics.fromJson(statsJson),
      pagination: PatientPagination.fromJson(pagJson),
      patients: patientsList
          .map((e) => Patient.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
