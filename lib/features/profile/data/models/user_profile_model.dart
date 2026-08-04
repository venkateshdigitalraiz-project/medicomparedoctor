import 'package:equatable/equatable.dart';

/// Simple stat card model (Total Patients / Total Appt / Completed).
class UserStatModel extends Equatable {
  final String value;
  final String label;
  final String iconAsset; // logical name, mapped to an IconData in the UI
  final int colorValue; // background tint for the stat icon

  const UserStatModel({
    required this.value,
    required this.label,
    required this.iconAsset,
    required this.colorValue,
  });

  @override
  List<Object?> get props => [value, label, iconAsset, colorValue];
}

/// Core profile model for the Doctor.
class UserProfileModel extends Equatable {
  final String name;
  final String specialty;
  final String id;
  final String avatarUrl;
  final bool isVerified;
  final String email;
  final String phoneNumber;
  final String gender;
  final String address;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String experience;
  final bool isAvailableNow;
  final List<UserStatModel> stats;

  const UserProfileModel({
    required this.name,
    required this.specialty,
    required this.id,
    required this.avatarUrl,
    required this.isVerified,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.address,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.experience,
    required this.isAvailableNow,
    required this.stats,
  });

  /// Factory constructor to parse the profile response from the API.
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    // Parse specialty (services)
    String specialty = 'Not Available';
    final services = data['services'];
    if (services is Map) {
      specialty = services['name']?.toString() ?? 'Not Available';
    } else if (services is List && services.isNotEmpty) {
      final firstService = services[0];
      if (firstService is Map) {
        specialty = firstService['name']?.toString() ?? 'Not Available';
      } else {
        specialty = firstService.toString();
      }
    } else if (services is String) {
      specialty = services;
    }

    final experienceStr = data['experience']?.toString() ?? 'Not Available';

    // Statistics mapping
    final totalPatients = data['totalPatientCount']?.toString() ?? '0';
    final totalAppts = data['totalAppointmentCount']?.toString() ?? '0';
    final completed = data['completedCount']?.toString() ?? '0';

    final stats = [
      UserStatModel(
        value: totalPatients,
        label: 'Total Patients',
        iconAsset: 'patients',
        colorValue: 0xFF2F80ED,
      ),
      UserStatModel(
        value: totalAppts,
        label: 'Total Appt',
        iconAsset: 'appointments',
        colorValue: 0xFFF2994A,
      ),
      UserStatModel(
        value: completed,
        label: 'Completed',
        iconAsset: 'completed',
        colorValue: 0xFF27AE60,
      ),
    ];

    return UserProfileModel(
      name: data['name']?.toString() ?? 'Not Available',
      specialty: specialty,
      id: data['id']?.toString() ?? data['_id']?.toString() ?? 'Not Available',
      avatarUrl: data['avatarUrl']?.toString() ?? '',
      isVerified: data['isVerified'] == true || data['status'] == 'active',
      email: 'Not Available', // API does not return email
      phoneNumber: data['mobile']?.toString() ?? 'Not Available',
      gender: data['gender']?.toString() ?? 'Not Available',
      address: data['address']?.toString() ?? 'Not Available',
      status: data['status']?.toString() ?? 'Not Available',
      createdAt: data['createdAt']?.toString() ?? 'Not Available',
      updatedAt: data['updatedAt']?.toString() ?? 'Not Available',
      experience: experienceStr,
      isAvailableNow: data['isAvailableNow'] == true || data['status'] == 'active',
      stats: stats,
    );
  }

  /// Mock data mirroring the provided design.
  factory UserProfileModel.mock() {
    return const UserProfileModel(
      name: 'Dr. Sarah Johnson',
      specialty: 'Cardiologist',
      id: '156456456656',
      avatarUrl:
          'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=400',
      isVerified: true,
      email: 'Sarah@gmail.comi',
      phoneNumber: '9984324657',
      gender: 'Female',
      address: 'Not Available',
      status: 'active',
      createdAt: 'Not Available',
      updatedAt: 'Not Available',
      experience: '10',
      isAvailableNow: true,
      stats: [
        UserStatModel(
          value: '1.2k',
          label: 'Total Patients',
          iconAsset: 'patients',
          colorValue: 0xFF2F80ED,
        ),
        UserStatModel(
          value: '900',
          label: 'Total Appt',
          iconAsset: 'appointments',
          colorValue: 0xFFF2994A,
        ),
        UserStatModel(
          value: '850',
          label: 'Completed',
          iconAsset: 'completed',
          colorValue: 0xFF27AE60,
        ),
      ],
    );
  }

  UserProfileModel copyWith({
    String? name,
    String? specialty,
    String? id,
    String? avatarUrl,
    bool? isVerified,
    String? email,
    String? phoneNumber,
    String? gender,
    String? address,
    String? status,
    String? createdAt,
    String? updatedAt,
    String? experience,
    bool? isAvailableNow,
    List<UserStatModel>? stats,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      id: id ?? this.id,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      experience: experience ?? this.experience,
      isAvailableNow: isAvailableNow ?? this.isAvailableNow,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [
    name,
    specialty,
    id,
    avatarUrl,
    isVerified,
    email,
    phoneNumber,
    gender,
    address,
    status,
    createdAt,
    updatedAt,
    experience,
    isAvailableNow,
    stats,
  ];
}

/// Identifies the collapsible sections on the profile screen.
enum UserProfileSection {
  personalInformation,
  professionalInformation,
  workingHours,
  clinicalInformation,
  document,
}

/// Identifies bottom navigation destinations.
enum UserBottomNavItem { home, schedule, patients, profile }
