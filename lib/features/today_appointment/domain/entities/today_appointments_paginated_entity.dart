import 'package:equatable/equatable.dart';
import 'package:medicompare/features/today_appointment/domain/entities/today_appointment_entity.dart';

class TodayAppointmentsPaginatedEntity extends Equatable {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final List<TodayAppointmentEntity> list;

  const TodayAppointmentsPaginatedEntity({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.list,
  });

  @override
  List<Object?> get props => [total, page, limit, totalPages, list];
}
