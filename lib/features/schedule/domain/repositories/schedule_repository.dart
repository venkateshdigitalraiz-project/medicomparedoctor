import 'package:medicompare/features/schedule/data/models/appointment.dart';

abstract class ScheduleRepository {
  Future<ScheduleResponse> fetchSchedule({
    required int page,
    required int limit,
    String? date,
  });
}
