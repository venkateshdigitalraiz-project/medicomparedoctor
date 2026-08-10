import 'package:flutter/material.dart';

/// The kind of notification, used to pick an icon + color for the
/// leading avatar. Keeping this as an enum (rather than raw strings)
/// makes the UI layer a simple switch instead of scattered if/else.
enum NotificationType {
  appointmentConfirmed,
  newAppointmentRequest,
  videoConsultation,
  appointmentCancelled,
  paymentReceived,
  newMessage,
}

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String subtitle;
  final String timeLabel;

  const NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timeLabel,
  });

  /// Visual config (icon + colors) derived from [type].
  IconData get icon {
    switch (type) {
      case NotificationType.appointmentConfirmed:
        return Icons.event_available_rounded;
      case NotificationType.newAppointmentRequest:
        return Icons.person_add_alt_1_rounded;
      case NotificationType.videoConsultation:
        return Icons.videocam_rounded;
      case NotificationType.appointmentCancelled:
        return Icons.close_rounded;
      case NotificationType.paymentReceived:
        return Icons.credit_card_rounded;
      case NotificationType.newMessage:
        return Icons.chat_bubble_rounded;
    }
  }

  Color get iconBackgroundColor {
    switch (type) {
      case NotificationType.appointmentConfirmed:
        return const Color(0xFFEDE4FF);
      case NotificationType.newAppointmentRequest:
        return const Color(0xFFFCE3D4);
      case NotificationType.videoConsultation:
        return const Color(0xFFD3F5E8);
      case NotificationType.appointmentCancelled:
        return const Color(0xFFFBDADA);
      case NotificationType.paymentReceived:
        return const Color(0xFFD3F5E8);
      case NotificationType.newMessage:
        return const Color(0xFFDCE6FF);
    }
  }

  Color get iconColor {
    switch (type) {
      case NotificationType.appointmentConfirmed:
        return const Color(0xFF7C4DFF);
      case NotificationType.newAppointmentRequest:
        return const Color(0xFFE8794A);
      case NotificationType.videoConsultation:
        return const Color(0xFF1FAA6F);
      case NotificationType.appointmentCancelled:
        return const Color(0xFFE23E3E);
      case NotificationType.paymentReceived:
        return const Color(0xFF1FAA6F);
      case NotificationType.newMessage:
        return const Color(0xFF3B6BF5);
    }
  }

  /// "Now" / "5 min ago" style labels are highlighted green in the design,
  /// while day-based labels ("Yesterday", a date) are shown in muted grey.
  bool get isRecentLabel =>
      timeLabel == 'Now' || timeLabel.toLowerCase().contains('min ago');
}
