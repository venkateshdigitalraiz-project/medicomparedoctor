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
    required this.isAvailableNow,
    required this.stats,
  });

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
