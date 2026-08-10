import 'package:medicompare/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:medicompare/features/schedule/data/models/appointment.dart';

class GetScheduleUseCase {
  final ScheduleRepository repository;

  GetScheduleUseCase(this.repository);

  Future<ScheduleResponse> call({
    required int page,
    required int limit,
    String? date,
  }) async {
    return await repository.fetchSchedule(page: page, limit: limit, date: date);
  }
}
