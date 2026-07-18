import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/faq_item.dart';

/// Cubit holds the list of FAQ items and handles expand/collapse logic.
class FaqCubit extends Cubit<List<FaqItem>> {
  FaqCubit()
      : super([
          FaqItem(
            icon: Icons.event_available_outlined,
            question: 'How can I book an appointment?',
            answer:
                'Go to the Home tab, select a doctor or service, choose an '
                'available slot, and confirm your booking. You will receive '
                'a confirmation notification once it is booked.',
          ),
          FaqItem(
            icon: Icons.history_outlined,
            question: 'How do I reschedule or cancel?',
            answer:
                'Open "My Appointments", select the appointment you want to '
                'change, then tap Reschedule or Cancel. Changes made at '
                'least 2 hours before the slot are free of charge.',
          ),
          FaqItem(
            icon: Icons.description_outlined,
            question: 'Access consultation history?',
            answer:
                'Your full consultation history, including prescriptions '
                'and notes, is available under Profile > Consultation '
                'History.',
          ),
          FaqItem(
            icon: Icons.person_outline,
            question: 'Update profile information?',
            answer:
                'Navigate to Profile > Edit Profile to update your name, '
                'contact details, and preferences at any time.',
          ),
        ]);

  /// Toggles the expanded state of the FAQ item at [index].
  void toggleExpand(int index) {
    final updated = List<FaqItem>.from(state);
    updated[index] = updated[index].copyWith(
      isExpanded: !updated[index].isExpanded,
    );
    emit(updated);
  }
}
