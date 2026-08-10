import 'package:flutter/foundation.dart';
import 'package:medicompare/features/privacy_policy/data/models/privacy_policy_item.dart';

/// Base state for the Privacy Policy screen.
@immutable
abstract class PrivacyPolicyState {
  const PrivacyPolicyState();
}

/// Shown briefly while the (simulated) data is being prepared.
class PrivacyPolicyLoading extends PrivacyPolicyState {
  const PrivacyPolicyLoading();
}

/// Shown once the list of policy sections is ready to render.
class PrivacyPolicyLoaded extends PrivacyPolicyState {
  final List<PrivacyPolicyItem> items;
  const PrivacyPolicyLoaded(this.items);
}

/// Shown if something goes wrong while loading the data.
class PrivacyPolicyError extends PrivacyPolicyState {
  final String message;
  const PrivacyPolicyError(this.message);
}
