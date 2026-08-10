import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/notification/data/models/notification_model.dart';
import 'package:medicompare/features/notification/presentation/bloc/notification_event.dart';
import 'package:medicompare/features/notification/presentation/bloc/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoad);
    on<RefreshNotifications>(_onRefresh);
    on<DismissNotification>(_onDismiss);
  }

  Future<void> _onLoad(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      // Simulated network / repository call.
      await Future.delayed(const Duration(milliseconds: 400));
      emit(NotificationLoaded(_mockNotifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onRefresh(
    RefreshNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    // Keep showing current list while refreshing in the background.
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      emit(NotificationLoaded(_mockNotifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  void _onDismiss(DismissNotification event, Emitter<NotificationState> emit) {
    final current = state;
    if (current is NotificationLoaded) {
      final updated = current.notifications
          .where((n) => n.id != event.id)
          .toList(growable: false);
      emit(NotificationLoaded(updated));
    }
  }

  static final List<NotificationItem> _mockNotifications = [
    const NotificationItem(
      id: '1',
      type: NotificationType.appointmentConfirmed,
      title: 'Appointment Confirmed',
      subtitle: 'Your appointment with Robert  Fox is confirmed for 09:30 AM.',
      timeLabel: 'Now',
    ),
    const NotificationItem(
      id: '2',
      type: NotificationType.newAppointmentRequest,
      title: 'New Appointment Request',
      subtitle: 'Sarah Johnson requested an appointment for tomorrow.',
      timeLabel: '5 min ago',
    ),
    const NotificationItem(
      id: '3',
      type: NotificationType.videoConsultation,
      title: 'Video Consultation Starting',
      subtitle:
          'Your video consultation with Bessie Cooper will start in 10 minutes.',
      timeLabel: '5 min ago',
    ),
    const NotificationItem(
      id: '4',
      type: NotificationType.appointmentCancelled,
      title: 'Appointment  Cancelled',
      subtitle: 'The appointment with Jane Cooper has been cancelled.',
      timeLabel: '5 min ago',
    ),
    const NotificationItem(
      id: '5',
      type: NotificationType.paymentReceived,
      title: 'Payment Received',
      subtitle:
          'Payment of ₹500 from Robert Fox has been received  successfully.',
      timeLabel: 'Yesterday',
    ),
    const NotificationItem(
      id: '6',
      type: NotificationType.newMessage,
      title: 'New Message',
      subtitle:
          'You have a new message from Dr. Arlene McCoy regarding report.',
      timeLabel: '23 June 2026',
    ),
  ];
}
