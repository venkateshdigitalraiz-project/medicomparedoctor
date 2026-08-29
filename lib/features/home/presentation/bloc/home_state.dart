part of 'home_bloc.dart';

enum HomeTab { overview, appointments }

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final ClinicStatus clinicStatus;
  final OverviewStats stats;
  final List<Appointment> appointments;
  final String searchQuery;
  final HomeTab selectedTab;
  final int bottomNavIndex;
  final String? errorMessage;

  // Pagination
  final int currentPage;
  final int totalPages;
  final bool isLoadingNextPage;
  final bool hasReachedEnd;

  const HomeState({
    this.status = HomeStatus.initial,
    this.clinicStatus = const ClinicStatus(
      isAvailable: true,
      openTime: '09:00 AM',
      closeTime: '05:00 PM',
      capacityPercent: 0.9,
    ),
    this.stats = const OverviewStats(
      totalAppointments: 0,
      completedVisits: 0,
      upcomingConsults: 0,
      cancelled: 0,
    ),
    this.appointments = const [],
    this.searchQuery = '',
    this.selectedTab = HomeTab.overview,
    this.bottomNavIndex = 0,
    this.errorMessage,
    // Pagination defaults
    this.currentPage = 1,
    this.totalPages = 0,
    this.isLoadingNextPage = false,
    this.hasReachedEnd = false,
  });

  /// Appointments filtered by the current search query (name based).
  List<Appointment> get filteredAppointments {
    if (searchQuery.trim().isEmpty) return appointments;
    final q = searchQuery.toLowerCase();
    return appointments
        .where((a) => a.patientName.toLowerCase().contains(q))
        .toList();
  }

  HomeState copyWith({
    HomeStatus? status,
    ClinicStatus? clinicStatus,
    OverviewStats? stats,
    List<Appointment>? appointments,
    String? searchQuery,
    HomeTab? selectedTab,
    int? bottomNavIndex,
    String? errorMessage,
    int? currentPage,
    int? totalPages,
    bool? isLoadingNextPage,
    bool? hasReachedEnd,

    /// Pass true to explicitly clear the errorMessage field.
    bool clearError = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      clinicStatus: clinicStatus ?? this.clinicStatus,
      stats: stats ?? this.stats,
      appointments: appointments ?? this.appointments,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTab: selectedTab ?? this.selectedTab,
      bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoadingNextPage: isLoadingNextPage ?? this.isLoadingNextPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object?> get props => [
    status,
    clinicStatus,
    stats,
    appointments,
    searchQuery,
    selectedTab,
    bottomNavIndex,
    errorMessage,
    currentPage,
    totalPages,
    isLoadingNextPage,
    hasReachedEnd,
  ];
}
