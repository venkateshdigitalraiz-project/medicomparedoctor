import 'package:equatable/equatable.dart';
import 'package:medicompare/schedule_setting/model/schedule_models.dart';

enum SaveStatus { idle, saving, success, failure }

class ScheduleState extends Equatable {
  // Top availability toggle
  final bool isCurrentlyAvailable;
  final String lastUpdated;

  // Consultation hours
  final String morningStart;
  final String morningEnd;
  final String eveningStart;
  final String eveningEnd;

  // Slot configuration
  final String slotDuration;
  final String bufferTime;
  final int maxAppointmentsPerDay;

  // Consultation types
  final bool inPersonEnabled;
  final bool videoCallEnabled;
  final bool homeVisitEnabled;

  // Appointment rules
  final bool autoAcceptBookings;
  final bool allowSameDayBooking;
  final bool reschedulingAllowed;

  // Blocked slots
  final List<BlockedSlot> blockedSlots;

  // Schedule summary (derived / editable text)
  final String weekdaySummary; // Mon - Fri
  final String saturdaySummary;
  final bool sundayUnavailable;

  // Holidays & leave
  final bool vacationMode;
  final List<Holiday> holidays;

  final SaveStatus saveStatus;

  const ScheduleState({
    this.isCurrentlyAvailable = true,
    this.lastUpdated = '10:30 AM',
    this.morningStart = '09:00 AM',
    this.morningEnd = '01:00 PM',
    this.eveningStart = '04:00 PM',
    this.eveningEnd = '08:00 PM',
    this.slotDuration = '15 Min',
    this.bufferTime = 'No Buffer',
    this.maxAppointmentsPerDay = 25,
    this.inPersonEnabled = true,
    this.videoCallEnabled = true,
    this.homeVisitEnabled = false,
    this.autoAcceptBookings = true,
    this.allowSameDayBooking = false,
    this.reschedulingAllowed = true,
    this.blockedSlots = const [
      BlockedSlot(
        id: '1',
        title: 'Lunch Break',
        subtitle: 'Daily • 01:00 PM - 02:00 PM',
      ),
      BlockedSlot(
        id: '2',
        title: 'Hospital Meeting',
        subtitle: 'Every Wed • 10:00 AM - 11:00 AM',
      ),
    ],
    this.weekdaySummary = '09:00 AM - 08:00 PM',
    this.saturdaySummary = '09:00 AM - 01:00 PM',
    this.sundayUnavailable = true,
    this.vacationMode = true,
    this.holidays = const [
      Holiday(
        id: '1',
        day: '25',
        month: 'Dec',
        title: 'Christmas Break',
        duration: 'Duration: 3 Days',
      ),
    ],
    this.saveStatus = SaveStatus.idle,
  });

  ScheduleState copyWith({
    bool? isCurrentlyAvailable,
    String? lastUpdated,
    String? morningStart,
    String? morningEnd,
    String? eveningStart,
    String? eveningEnd,
    String? slotDuration,
    String? bufferTime,
    int? maxAppointmentsPerDay,
    bool? inPersonEnabled,
    bool? videoCallEnabled,
    bool? homeVisitEnabled,
    bool? autoAcceptBookings,
    bool? allowSameDayBooking,
    bool? reschedulingAllowed,
    List<BlockedSlot>? blockedSlots,
    String? weekdaySummary,
    String? saturdaySummary,
    bool? sundayUnavailable,
    bool? vacationMode,
    List<Holiday>? holidays,
    SaveStatus? saveStatus,
  }) {
    return ScheduleState(
      isCurrentlyAvailable: isCurrentlyAvailable ?? this.isCurrentlyAvailable,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      morningStart: morningStart ?? this.morningStart,
      morningEnd: morningEnd ?? this.morningEnd,
      eveningStart: eveningStart ?? this.eveningStart,
      eveningEnd: eveningEnd ?? this.eveningEnd,
      slotDuration: slotDuration ?? this.slotDuration,
      bufferTime: bufferTime ?? this.bufferTime,
      maxAppointmentsPerDay:
          maxAppointmentsPerDay ?? this.maxAppointmentsPerDay,
      inPersonEnabled: inPersonEnabled ?? this.inPersonEnabled,
      videoCallEnabled: videoCallEnabled ?? this.videoCallEnabled,
      homeVisitEnabled: homeVisitEnabled ?? this.homeVisitEnabled,
      autoAcceptBookings: autoAcceptBookings ?? this.autoAcceptBookings,
      allowSameDayBooking: allowSameDayBooking ?? this.allowSameDayBooking,
      reschedulingAllowed: reschedulingAllowed ?? this.reschedulingAllowed,
      blockedSlots: blockedSlots ?? this.blockedSlots,
      weekdaySummary: weekdaySummary ?? this.weekdaySummary,
      saturdaySummary: saturdaySummary ?? this.saturdaySummary,
      sundayUnavailable: sundayUnavailable ?? this.sundayUnavailable,
      vacationMode: vacationMode ?? this.vacationMode,
      holidays: holidays ?? this.holidays,
      saveStatus: saveStatus ?? this.saveStatus,
    );
  }

  @override
  List<Object?> get props => [
    isCurrentlyAvailable,
    lastUpdated,
    morningStart,
    morningEnd,
    eveningStart,
    eveningEnd,
    slotDuration,
    bufferTime,
    maxAppointmentsPerDay,
    inPersonEnabled,
    videoCallEnabled,
    homeVisitEnabled,
    autoAcceptBookings,
    allowSameDayBooking,
    reschedulingAllowed,
    blockedSlots,
    weekdaySummary,
    saturdaySummary,
    sundayUnavailable,
    vacationMode,
    holidays,
    saveStatus,
  ];
}
