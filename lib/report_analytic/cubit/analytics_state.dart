import 'package:equatable/equatable.dart';
import '../models/analytics_data.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

/// Initial / loading state — shown while data is being fetched.
class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

/// Data successfully loaded and ready to render.
class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsData data;

  const AnalyticsLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

/// Something went wrong fetching the analytics data.
class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}
