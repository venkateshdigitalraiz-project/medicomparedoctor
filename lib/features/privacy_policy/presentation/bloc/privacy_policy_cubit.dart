import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicompare/features/privacy_policy/data/models/privacy_policy_item.dart';
import 'package:medicompare/features/privacy_policy/presentation/bloc/privacy_policy_state.dart';

/// Cubit responsible for loading and holding the Privacy Policy content.
///
/// In a real app `loadPolicies()` might call an API or read a local asset.
/// Here it simulates a short load and then emits the static sections shown
/// in the design.
class PrivacyPolicyCubit extends Cubit<PrivacyPolicyState> {
  PrivacyPolicyCubit() : super(const PrivacyPolicyLoading());

  Future<void> loadPolicies() async {
    emit(const PrivacyPolicyLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final items = <PrivacyPolicyItem>[
        PrivacyPolicyItem(
          icon: Icons.shield_outlined,
          iconColor: const Color(0xFF7C3AED),
          iconBackgroundColor: const Color(0xFFF3E8FF),
          title: 'Your Privacy Matters',
          description:
              'Learn how we collect, use, and protect your information '
              'within our medical management ecosystem.',
        ),
        PrivacyPolicyItem(
          icon: Icons.person_outline,
          iconColor: const Color(0xFF2563EB),
          iconBackgroundColor: const Color(0xFFDCEBFF),
          title: 'Information We Collect',
          description:
              'We collect doctor profile information, clinic details, '
              'appointment records, and consultation data to provide '
              'healthcare management services.',
        ),
        PrivacyPolicyItem(
          icon: Icons.storage_outlined,
          iconColor: const Color(0xFFCA8A04),
          iconBackgroundColor: const Color(0xFFFEF3C7),
          title: 'How We Use Your Data',
          description:
              'Your information is used to manage appointments, patient '
              'records, schedules, communication, and improve app '
              'performance.',
        ),
        PrivacyPolicyItem(
          icon: Icons.folder_outlined,
          iconColor: const Color(0xFFDC2626),
          iconBackgroundColor: const Color(0xFFFCE1E1),
          title: 'Data Security',
          description:
              'We use secure encryption and industry-standard protection '
              'measures to safeguard your personal and professional '
              'information.',
        ),
        PrivacyPolicyItem(
          icon: Icons.groups_outlined,
          iconColor: const Color(0xFF059669),
          iconBackgroundColor: const Color(0xFFD9F5E8),
          title: 'Patient Confidentiality',
          description:
              'Patient records and consultation data remain confidential '
              'and are only accessible to authorized users.',
        ),
        PrivacyPolicyItem(
          icon: Icons.hub_outlined,
          iconColor: const Color(0xFFCA8A04),
          iconBackgroundColor: const Color(0xFFFEF3C7),
          title: 'Third-Party Services',
          description:
              'We may integrate trusted healthcare and communication '
              'services while maintaining strict privacy standards.',
        ),
        PrivacyPolicyItem(
          icon: Icons.support_agent_outlined,
          iconColor: const Color(0xFF7C3AED),
          iconBackgroundColor: const Color(0xFFF3E8FF),
          title: 'Contact & Support',
          description:
              'For privacy-related concerns or questions, contact our '
              'specialized medical support team available 24/7.',
        ),
      ];

      emit(PrivacyPolicyLoaded(items));
    } catch (e) {
      emit(PrivacyPolicyError(e.toString()));
    }
  }
}
