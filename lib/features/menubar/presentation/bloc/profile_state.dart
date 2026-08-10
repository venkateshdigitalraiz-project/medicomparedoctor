part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final DoctorProfile profile;
  final List<MenuItem> menuItems;

  /// Transient field: set right after a menu row / header icon is tapped so
  /// the UI can react (e.g. navigate) via BlocListener, then cleared.
  final String? navigationTarget;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile = const DoctorProfile(
      name: '',
      qualification: '',
      specialty: '',
      id: '',
      avatarUrl: '',
    ),
    this.menuItems = const [],
    this.navigationTarget,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    DoctorProfile? profile,
    List<MenuItem>? menuItems,
    String? navigationTarget,
    bool clearNavigationTarget = false,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      menuItems: menuItems ?? this.menuItems,
      navigationTarget:
          clearNavigationTarget ? null : navigationTarget ?? this.navigationTarget,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, profile, menuItems, navigationTarget, errorMessage];
}
